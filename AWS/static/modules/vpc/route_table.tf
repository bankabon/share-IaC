/**
 * for public subnet route table
*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bankabon-test.id

  tags = merge(
    local.tags,
    {
      Name = format("%s_public", var.env_name)
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnet_cidrs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id

  lifecycle {
    prevent_destroy = false
  }
}

/**
 * for private subnet route table
 */
resource "aws_route_table" "private" {

  vpc_id = aws_vpc.bankabon-test.id

  tags = merge(
    local.tags,
    {
      Name = format("%s_private", var.env_name)
    }
  )
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnet_cidrs

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id

  lifecycle {
    prevent_destroy = false
  }
}

/**
 * for public Subnet route table on nat
 */

 resource "aws_route_table" "public_nat" {

  vpc_id = aws_vpc.bankabon-test.id

  tags = merge(
    local.tags,
    {
      Name = format("%s_nat", var.env_name)
    }
  )
  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_route_table_association" "public_nat_route" {
  for_each = var.public_subnet_nat_cidrs

  subnet_id      = aws_subnet.public_nat[each.key].id
  route_table_id = aws_route_table.public_nat.id

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_route_table_association" "public_alb_route" {
  for_each = var.public_subnet_alb_cidrs

  subnet_id      = aws_subnet.public_alb[each.key].id
  route_table_id = aws_route_table.public.id

  lifecycle {
    prevent_destroy = false
  }
}