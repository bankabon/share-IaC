#codebuild project作成
resource "aws_codebuild_project" "nginx-app" {
  name = "${var.env}-${var.name}-build-project"

  service_role = aws_iam_role.code_build.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id  = var.vpc_id
    subnets = [var.subnet_ids_code]

    security_group_ids = [
      "${aws_security_group.codepipeline.id}"
    ]
  }


}