#NAT GATEWAY不使用
/*
resource "aws_eip" "nat_gateway" {

  vpc = true
  tags = merge(
    local.tags,
    {
      Name = format("%s_nat_gateway", var.env_prefix)
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}
*/
