resource "aws_security_group" "app_runner_sg" {
  name        = "${var.env}-${var.name}-apprunner"
  vpc_id      = var.vpc_id
  description = "apprunner-securitygroup"
}

# 全アウトバウンド許可
resource "aws_security_group_rule" "app_runner_sg_out" {
  type              = "egress"
  security_group_id = aws_security_group.app_runner_sg.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# インバウンド
resource "aws_security_group_rule" "app_runner_sg_in" {
  type                     = "ingress"
  security_group_id        = aws_security_group.app_runner_sg.id
  protocol                 = "tcp"
  from_port                = "3306"
  to_port                  = "3306"
  source_security_group_id = aws_security_group.app_runner_sg.id
}


#http,httpsの許可
resource "aws_security_group" "app_runner_http" {
  name   = "${var.env}-${var.name}-apprunner-http"
  vpc_id = var.vpc_id
}

# 全アウトバウンド許可
resource "aws_security_group_rule" "app_runner_http_out" {
  type              = "egress"
  security_group_id = aws_security_group.app_runner_http.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
#httpインバウンド許可
resource "aws_security_group_rule" "app_runner_http_in" {
  type                     = "ingress"
  security_group_id        = aws_security_group.app_runner_http.id
  protocol                 = "tcp"
  from_port                = "80"
  to_port                  = "80"
  source_security_group_id = aws_security_group.app_runner_http.id
}

#httpsインバウンド許可
resource "aws_security_group_rule" "app_runner_https_in" {
  type                     = "ingress"
  security_group_id        = aws_security_group.app_runner_http.id
  protocol                 = "tcp"
  from_port                = "443"
  to_port                  = "443"
  source_security_group_id = aws_security_group.app_runner_http.id
}

resource "aws_security_group_rule" "app_runner_all_in" {
  type                     = "ingress"
  security_group_id        = aws_security_group.app_runner_http.id
  protocol                 = "-1"
  from_port                = "0"
  to_port                  = "0"
  source_security_group_id = aws_security_group.app_runner_http.id
}


#codebuild用セキュリティーGP
resource "aws_security_group" "codebuild_sg" {
  count       = var.use_github == true ? 0 : 1
  name        = "${var.env}-${var.name}-codebuild"
  vpc_id      = var.vpc_id
  description = "codebuild-securitygroup"
}

resource "aws_security_group_rule" "codebuild_all_in" {
  count                    = var.use_github == true ? 0 : 1
  type                     = "ingress"
  security_group_id        = aws_security_group.codebuild_sg[0].id
  protocol                 = "-1"
  from_port                = "0"
  to_port                  = "0"
  source_security_group_id = aws_security_group.codebuild_sg[0].id
}

# 全アウトバウンド許可
resource "aws_security_group_rule" "codebuild_http_out" {
  count             = var.use_github == true ? 0 : 1
  type              = "egress"
  security_group_id = aws_security_group.codebuild_sg[0].id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}