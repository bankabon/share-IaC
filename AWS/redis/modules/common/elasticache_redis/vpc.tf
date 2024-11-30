data "aws_vpc" "test_vpc" {
  id = local.vpc_id
}

data "aws_vpc" "test_bankabon" {
  tags = {
    Env     = var.env
    Name    = var.service
    Service = var.service
  }
}
