#クラウドウォッチlog group
resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs/logs/${var.env}-${var.name}"

  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}