resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.bankabon-test.id

  tags = merge(
    local.tags,
    {
      Name = "${var.env_name}_default"
      Env  = var.environment
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}
