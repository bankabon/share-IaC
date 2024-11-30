resource "aws_ecs_cluster" "cluster" {

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  name = "${var.name}-${var.env}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
