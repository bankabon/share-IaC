/*
resource "aws_nat_gateway" "private" {
  for_each = var.public_subnet_nat_cidrs

  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.public_nat[each.key].id

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s_%s", var.env_prefix, var.env_name, "nat-gateway")
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}
 */
