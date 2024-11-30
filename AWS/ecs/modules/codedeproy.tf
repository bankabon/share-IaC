#コードデプロイアプリケーション
resource "aws_codedeploy_app" "app-ecs-codeapp" {
  compute_platform = "ECS"
  name             = "ecs-${var.env}-${var.name}-app"
}

#デプロイグループ作成
resource "aws_codedeploy_deployment_group" "app-ecs-deployment-group" {
  app_name               = aws_codedeploy_app.app-ecs-codeapp.name
  deployment_config_name = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"
  deployment_group_name  = "${var.name}-deploygroup"
  service_role_arn       = aws_iam_role.codedeploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.cluster.name
    service_name = aws_ecs_service.nginx-php.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.main.arn]
      }

      target_group {
        name = aws_lb_target_group.nginx-php-tg2.name
      }

      target_group {
        name = aws_lb_target_group.nginx-php-tg.name
      }
    }
  }
}
