#ロードバランサー
resource "aws_lb" "alb" {
  desync_mitigation_mode           = "defensive"
  drop_invalid_header_fields       = "false"
  enable_cross_zone_load_balancing = "true"
  enable_deletion_protection       = "false"
  enable_http2                     = "true"
  enable_waf_fail_open             = "false"
  idle_timeout                     = "60"
  internal                         = "false"
  ip_address_type                  = "ipv4"
  load_balancer_type               = "application"
  name                             = "nginx-php-${var.env}-${var.name}"
  security_groups                  = [aws_security_group.sg-lb.id]

  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.alb.bucket
  }

  # subnet_mapping {
  #   subnet_id = var.sabnet_ids[0]
  # }

  # subnet_mapping {
  #   subnet_id = var.subnet_ids2[0]
  # }

  subnets = var.subnet_ids_alb
}

#443用ロードバランサー
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.alb.arn

  port            = "443"
  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.cert.arn #証明書acm.tf参照

  default_action {
    type = "forward"
    forward {
      stickiness {
        duration = "60"
        enabled  = "false" #デフォルトがこの値です。
      }

      target_group {
        arn    = aws_lb_target_group.nginx-php-tg.arn #ターゲットGP
        weight = "100"
      }

      target_group {
        arn    = aws_lb_target_group.nginx-php-tg2.arn #ターゲットGP
        weight = "0"
      }
    }
  }
}

#80番ポートロードバランサー
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn

  port     = var.port
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443" #443にリダイレクト
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#ターゲットグループ
resource "aws_lb_target_group" "nginx-php-tg2" {
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "10"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.env}-${var.name}-ecs-tg2"
  port                          = var.port
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false" #デフォルトがこの値です。
    type            = "lb_cookie"
  }

  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_target_group" "nginx-php-tg" {
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "5"
    interval            = "10"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.env}-${var.name}-ecs-tg"
  port                          = var.port
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false" #デフォルトがこの値です。
    type            = "lb_cookie"
  }

  target_type = "ip"
  vpc_id      = var.vpc_id
}

