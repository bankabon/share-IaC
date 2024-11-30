data "aws_subnet" "private_a" {
  vpc_id = data.aws_vpc.test_vpc.id
  tags   = { Name = "${local.env_short_for_subnet}_${var.service}-${local.subnet_type}-1a" }
}

data "aws_subnet" "private_c" {
  vpc_id = data.aws_vpc.test_vpc.id
  tags   = { Name = "${local.env_short_for_subnet}_${var.service}-${local.subnet_type}-1c" }
}

data "aws_subnet" "private_d" {
  vpc_id = data.aws_vpc.test_vpc.id
  tags   = { Name = "${local.env_short_for_subnet}_${var.service}-${local.subnet_type}-1d" }
}

resource "aws_db_subnet_group" "private" {
  name        = local.subnet_group_name
  description = "${var.env_type} ${local.subnet_type} subnet group"
  subnet_ids = [
    data.aws_subnet.private_a.id,
    data.aws_subnet.private_c.id,
    data.aws_subnet.private_d.id,
  ]
}