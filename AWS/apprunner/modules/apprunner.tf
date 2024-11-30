resource "aws_apprunner_service" "create-apprunner" {
  service_name = "${var.env}_${var.name}-test-apprunner"

  #判定
  dynamic "source_configuration" {
    for_each = var.use_github ? [1] : []

    #use, github
    content {
      authentication_configuration {
        #connection_arn = aws_apprunner_connection.app_runner_vpc[0].arn #terraformで作成したい場合はこちらをONにする
        connection_arn = var.github_account_arn
      }
      auto_deployments_enabled = false
      code_repository {
        code_configuration {
          code_configuration_values {
            build_command = "yarn && yarn build"
            port          = "3000"
            runtime       = "NODEJS_16"
            start_command = "yarn start"
          }
          configuration_source = "API"
        }
        repository_url = var.github_repositoryurl
        source_code_version {
          type  = "BRANCH"
          value = var.branch
        }
      }
    }
  }

  #use ecr
  dynamic "source_configuration" {
    for_each = var.use_github ? [] : [1]

    content {
      authentication_configuration {
        access_role_arn = aws_iam_role.ecs-role[0].arn
      }
      image_repository {
        image_configuration {
          port = "8080"
        }
        image_identifier      = "${var.ecr_uri}:latest" #ecrリポジトリURI
        image_repository_type = "ECR"
      }
      auto_deployments_enabled = true
    }
  }

  instance_configuration {
    cpu               = "1024"
    memory            = "2048"
    instance_role_arn = aws_iam_role.role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }
}

#gitとのアカウント連携の部分自動化不可能のため、使う場合は一時停止が必要です。
# resource "aws_apprunner_connection" "app_runner_vpc" {
#   count           = var.use_github == true ? 1 : 0
#   connection_name = "${var.env}-${var.name}-github"
#   provider_type   = "GITHUB"
# }

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "${var.env}-${var.name}-vpc-connector"
  subnets            = var.apprunner_subnet
  security_groups    = [aws_security_group.app_runner_sg.id, aws_security_group.app_runner_http.id]
}

# resource "aws_apprunner_custom_domain_association" "domain_name" {
#   domain_name = var.domain_name
#   service_arn = aws_apprunner_service.create-apprunner.arn
# }

