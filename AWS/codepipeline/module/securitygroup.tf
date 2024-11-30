resource "aws_security_group" "codepipeline" {
  count = var.use_web == true ? 0 : 1
  name = "${var.env}-codepipeline-sg"
  description = "Security group for CodePipeline"
  vpc_id      = "${var.vpc_id}"

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
  count = var.use_web == true ? 0 : 1
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.codepipeline[0].id
  source_security_group_id = aws_security_group.codepipeline[0].id
}