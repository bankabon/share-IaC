#コードパイプライン
resource "aws_codepipeline" "nginx-app" {
  name     = "ecs-${var.env}-${var.name}"
  role_arn = aws_iam_role.service-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"

      configuration = {
        BranchName           = "${var.code-pipeline-branch}"
        ConnectionArn        = "${var.ConnectionArn}"
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

    name = "ContainerBuild"

    action {
      category = "Build"

      configuration = {
        ProjectName = aws_codebuild_project.nginx-app.name
        EnvironmentVariables = jsonencode([
          {
            name  = "SECRET_NAME"
            value = "${var.paramate_name}"
            type  = "PLAINTEXT"
          },
          {
            name  = "CLUSTER_NAME"
            value = "${aws_ecs_cluster.cluster.name}"
            type  = "PLAINTEXT"
          },
          {
            name  = "CPU"
            value = "${var.cpu}"
            type  = "PLAINTEXT"
          },
          {
            name  = "MEMORY"
            value = "${var.memory}"
            type  = "PLAINTEXT"
          },
        ])
      }

      input_artifacts  = ["SourceArtifact"]
      name             = "Build"
      namespace        = "BuildVariables"
      output_artifacts = ["BuildArtifact1", "BuildArtifact2", "BuildArtifact3" ,"BuildArtifact4", "BuildArtifact5"]
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "ap-northeast-1"
      run_order        = "1"
      version          = "1"
    }
  }

  stage {

    name = "ContainerDeploy"

    action {
      category = "Deploy"

      configuration = {
        ApplicationName                = aws_codedeploy_app.app-ecs-codeapp.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.app-ecs-deployment-group.app_name
        Image1ArtifactName             = "BuildArtifact1"
        Image1ContainerName            = "IMAGE_WEB"
        Image2ArtifactName             = "BuildArtifact2"
        Image2ContainerName            = "IMAGE_APP"
        Image3ArtifactName             = "BuildArtifact3"
        Image3ContainerName            = "IMAGE_LOG"
        Image4ArtifactName             = "BuildArtifact4"
        Image4ContainerName            = "IMAGE_FRONT"
        TaskDefinitionbankabonArtifact = "BuildArtifact5"
        TaskDefinitionbankabonPath     = "task.json"
        AppSpecbankabonArtifact        = "BuildArtifact5"
        AppSpecbankabonPath            = "appspec.yml"
      }

      input_artifacts = ["BuildArtifact1", "BuildArtifact2", "BuildArtifact3" ,"BuildArtifact4", "BuildArtifact5"]
      name            = "ecs-${var.env}-${var.name}-deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      region          = "ap-northeast-1"
      run_order       = "1"
      version         = "1"
    }
  }
}

#コード参照先コネクト
resource "aws_codestarconnections_connection" "connect" {
  count         = var.useconect == "no" ? 0 : 1
  name          = "${var.env}-${var.name}-connection"
  provider_type = "GitHub"
}
