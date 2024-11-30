resource "aws_codepipeline" "apprunner" {
  count    = var.use_github == true ? 0 : 1
  name     = "apprunner-container-${var.env}-${var.name}"
  role_arn = aws_iam_role.codepipeline[0].arn

  artifact_store {
    location = aws_s3_bucket.codepipeline[0].bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"

      configuration = {
        BranchName           = "${var.code-pipeline-branch}"
        ConnectionArn        = "${var.ConectionArn}"
        FullRepositoryId     = "${var.code-pipeline-repository}"
        OutputArtifactFormat = "CODE_ZIP"
      }

      name             = "Source"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceArtifact"]
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      region           = "ap-northeast-1"
      run_order        = "1"
      version          = "1"
    }
  }

  stage {
    name = "Approve"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

    }
  }

  stage {

    name = "Build"

    action {
      category = "Build"

      configuration = {
        ProjectName = aws_codebuild_project.apprunner[0].name
      }

      input_artifacts  = ["SourceArtifact"]
      name             = "Build"
      namespace        = "BuildVariables"
      output_artifacts = ["BuildArtifact1"]
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "ap-northeast-1"
      run_order        = "1"
      version          = "1"
    }
  }
}

resource "aws_codebuild_project" "apprunner" {
  count = var.use_github == true ? 0 : 1
  name  = "${var.env}-${var.name}-build-project"

  service_role = aws_iam_role.codebuild[0].arn

  source {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"#インスタンスタイプ
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0-23.05.22"#イメージ
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id  = var.vpc_id
    subnets = ["${var.codebuild_subnet}"]

    security_group_ids = [
      "${aws_security_group.codebuild_sg[0].id}"
    ]
  }

  logs_config {
    cloudwatch_logs {
      group_name = local.log#cloudwachのロググループを指定
    }
  }

}