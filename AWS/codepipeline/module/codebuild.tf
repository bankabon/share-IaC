resource "aws_codebuild_project" "project" {
  count = var.use_web == true ? 0 : 1
  name           = "${var.env}-${var.name}-codebuild-project"
  build_timeout  = "60"
  queued_timeout = "480"

  service_role = aws_iam_role.codebuild[0].arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "CODEPIPELINE"
  }

   vpc_config {
    vpc_id = "${var.vpc_id}"
    subnets = [ var.subnet_ids_code ]

    security_group_ids = [ 
      "${aws_security_group.codepipeline[0].id}"
     ]
  }
}