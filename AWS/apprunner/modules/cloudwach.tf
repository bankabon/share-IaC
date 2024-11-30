resource "aws_cloudwatch_log_group" "apprunner" {
  count = var.use_github == true ? 0 : 1
  name  = "apprunner/logs/${var.env}-${var.name}"

  tags = {
    Environment = "production"
    Application = "apprunner"
  }
}

#codepipeline用のlog監視