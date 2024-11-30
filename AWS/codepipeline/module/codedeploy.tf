resource "aws_codedeploy_app" "app" {
  compute_platform = "Server"
  name             = "${var.env}-${var.name}-codedeploy"
}

resource "aws_codedeploy_deployment_group" "app" {
  app_name               = aws_codedeploy_app.app.name
  deployment_group_name  = "${var.env}-${var.name}-group"
  service_role_arn       = aws_iam_role.appRole.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"


  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  autoscaling_groups = [var.autoscaling_groups]

  load_balancer_info {
    target_group_info {
      name = var.target_group_name
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 30
    }
  }

}