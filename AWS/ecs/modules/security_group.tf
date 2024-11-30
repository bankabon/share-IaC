#セキュリティーグループ作成
resource "aws_security_group" "ECS" {
  name   = "${var.env}-${var.name}-sg-ecs"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress_allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ECS.id
}

resource "aws_security_group_rule" "ingress_allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ECS.id
}

resource "aws_security_group_rule" "egress_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ECS.id
}

resource "aws_security_group" "sg-lb" {
  name        = "${var.env}-${var.name}-sg-lb"
  vpc_id      = var.vpc_id
  description = "${var.env}-${var.name}-sg-lb"

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "attach" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ECS.id
  source_security_group_id = aws_security_group.ECS.id
}

resource "aws_security_group_rule" "attach2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg-lb.id
  source_security_group_id = aws_security_group.ECS.id
}

resource "aws_security_group" "codepipeline" {
  name        = "${var.env}-codepipeline-sg"
  description = "Security group for CodePipeline"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "codepipeline-sg"
  }
}

resource "aws_security_group_rule" "codepopeline" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.codepipeline.id
  source_security_group_id = aws_security_group.codepipeline.id
}