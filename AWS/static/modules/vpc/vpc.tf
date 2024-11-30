resource "aws_vpc" "bankabon-test" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.tags,
    {
      Name = var.env_name
      Env  = var.environment
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}
