# Redisクラスターに付けるSecurity Group
resource "aws_security_group" "redis" {
  name        = local.security_group_name
  vpc_id      = data.aws_vpc.test_vpc.id
  description = local.security_group_description
  tags        = merge(local.base_tags, { Name = local.security_group_name })
}

# 全アウトバウンド許可
resource "aws_security_group_rule" "redis_egress" {
  type              = "egress"
  security_group_id = aws_security_group.redis.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# インバウンド
resource "aws_security_group_rule" "redis_ingress" {
  for_each = var.allowed_security_group_ids

  description              = "from ${each.key}"
  type                     = "ingress"
  security_group_id        = aws_security_group.redis.id
  protocol                 = "tcp"
  from_port                = local.port
  to_port                  = local.port
  source_security_group_id = each.value
}
