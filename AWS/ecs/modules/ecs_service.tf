resource "aws_ecs_service" "nginx-php" {
  cluster = aws_ecs_cluster.cluster.arn
  name    = "ecs-${var.env}-${var.name}"


  deployment_controller {
    type = "CODE_DEPLOY"
  }

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "100"
  desired_count                      = "1"
  enable_ecs_managed_tags            = "false"
  enable_execute_command             = "true"
  health_check_grace_period_seconds  = "0"
  launch_type                        = "FARGATE"

  load_balancer {
    container_name   = "web"
    container_port   = var.port
    target_group_arn = aws_lb_target_group.nginx-php-tg2.arn #ターゲットグループを指定
  }

  network_configuration {
    assign_public_ip = "true"
    security_groups  = [aws_security_group.ECS.id]
    subnets          = var.subnet_ids_ecs
  }

  platform_version    = "1.4.0"
  scheduling_strategy = "REPLICA"
  task_definition     = aws_ecs_task_definition.nginx-php.arn
}
