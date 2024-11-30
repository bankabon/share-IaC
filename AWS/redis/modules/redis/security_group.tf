data "aws_security_group" "roles" {
  for_each = toset(var.allowed_roles)
  tags = {
    Name = "${var.env_type}_${local.service}_${each.value}",
  }
}
