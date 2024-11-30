#taskrole
resource "aws_iam_role" "taskrole" {
  name               = "${var.env}-${var.name}-taskrole"
  assume_role_policy = file("../modules/json/taskrole.json")
}

resource "aws_iam_policy" "ecss-ssm" {
  name   = "${var.env}-${var.name}-ecs-ssm"
  path   = "/"
  policy = file("../modules/json/ecs-ssm.json")
}

resource "aws_iam_role_policy_attachment" "taskrole" {
  role       = aws_iam_role.taskrole.name
  policy_arn = aws_iam_policy.ecss-ssm.arn
}

resource "aws_iam_role_policy_attachment" "S3full" {
  role       = aws_iam_role.taskrole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "SSMfull" {
  role       = aws_iam_role.taskrole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

#execution role(task)
resource "aws_iam_role" "execution" {
  name               = "${var.env}-${var.name}-ecsTaskExecutionrole"
  assume_role_policy = file("../modules/json/taskexcution.json")
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionrole" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMFullAccess" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_policy" "NewRelicLicenseKeySecret" {
  name = "${var.env}-${var.name}-newrelicSSM"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameters"
          ],
          "Resource" : [
            "${aws_secretsmanager_secret.newrelic.arn}"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "newrelic" {
  role       = aws_iam_role.taskrole.name
  policy_arn = aws_iam_policy.NewRelicLicenseKeySecret.arn
}

#codepipeline
resource "aws_iam_role" "codedeproy" {
  name               = "${var.env}-${var.name}-codedeproy-role"
  path               = "/"
  assume_role_policy = file("../modules/json/codedeproy-role.json")
}

resource "aws_iam_policy" "codedeproy" {
  name   = "${var.env}-${var.name}-codedeproy-policy"
  path   = "/"
  policy = file("../modules/json/codedeproy-policy.json")
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codedeproy.name
  policy_arn = aws_iam_policy.codedeproy.arn
}

#codepipeline service role
resource "aws_iam_role" "service-role" {
  name               = "${var.env}-${var.name}-service-role"
  path               = "/"
  assume_role_policy = file("../modules/json/servicerole.json")
}

resource "aws_iam_policy" "service-policy" {
  name   = "${var.env}-${var.name}-service-policy"
  path   = "/"
  policy = file("../modules/json/servicepolicy.json")
}

resource "aws_iam_role_policy_attachment" "service-role-policy" {
  role       = aws_iam_role.service-role.name
  policy_arn = aws_iam_policy.service-policy.arn

}

#codebuild role
resource "aws_iam_role" "code_build" {
  name               = "${var.env}-${var.name}-ECS-code-build-role"
  path               = "/"
  assume_role_policy = file("../modules/json/codebuild_role.json")
}

resource "aws_iam_role_policy_attachment" "code_build_ec2" {
  role       = aws_iam_role.code_build.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "code_build_ecs" {
  role       = aws_iam_role.code_build.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "code_build_" {
  role       = aws_iam_role.code_build.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "code_build_ec2-2" {
  role       = aws_iam_role.code_build.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_policy" "code_build" {
  name = "${var.env}-${var.name}-ECS-code-buid-policy"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Resource" : [
            "*"
          ],
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "${local.bucket_arn}"
          ],
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::${local.bucket_name}",
            "arn:aws:s3:::${local.bucket_name}/*"
          ],
          "Action" : [
            "s3:PutObject",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ],
          "Resource" : [
            "${aws_codebuild_project.nginx-app.arn}/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy" "code_build_policy" {
  name = "${var.env}-${var.name}-code-buid-policy"
  path = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:logs:ap-northeast-1:${local.account}:log-group:/aws/codebuild/${aws_codebuild_project.nginx-app.name}",
            "arn:aws:logs:ap-northeast-1:${local.account}:log-group:/aws/codebuild/${aws_codebuild_project.nginx-app.name}:*"
          ],
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "${local.bucket_arn}-*"
          ],
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ],
          "Resource" : [
            "${aws_codebuild_project.nginx-app.arn}-*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "code_build" {
  role       = aws_iam_role.code_build.name
  policy_arn = aws_iam_policy.code_build.arn
}

resource "aws_iam_role_policy_attachment" "code_build_policy" {
  role       = aws_iam_role.code_build.name
  policy_arn = aws_iam_policy.code_build_policy.arn
}

#deploy
resource "aws_iam_role" "codedeploy" {
  name               = "${var.env}-${var.name}-deploy-role"
  assume_role_policy = file("../modules/json/deploy_role.json")
}

resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "ecs-deploy" {
  role       = aws_iam_role.codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}