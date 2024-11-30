/**
 * public subnet(Nat)
*/
resource "aws_subnet" "public_nat" {
  for_each = var.public_subnet_nat_cidrs

  vpc_id                  = aws_vpc.bankabon-test.id
  availability_zone       = lookup(each.value, "az")
  cidr_block              = lookup(each.value, "subnet")
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s", var.env_prefix, lookup(each.value, "name"))
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

# public subnet

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id                  = aws_vpc.bankabon-test.id
  availability_zone       = lookup(each.value, "az")
  cidr_block              = lookup(each.value, "subnet")
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s", var.env_prefix, lookup(each.value, "name"))
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

# public subnet(alb)

resource "aws_subnet" "public_alb" {
  for_each = var.public_subnet_alb_cidrs

  vpc_id                  = aws_vpc.bankabon-test.id
  availability_zone       = lookup(each.value, "az")
  cidr_block              = lookup(each.value, "subnet")
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s", var.env_prefix, lookup(each.value, "name"))
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}

/**
 * private subnet
 */
resource "aws_subnet" "private" {
  for_each = var.private_subnet_cidrs

  vpc_id                  = aws_vpc.bankabon-test.id
  availability_zone       = lookup(each.value, "az")
  cidr_block              = lookup(each.value, "subnet")
  map_public_ip_on_launch = false

  tags = merge(
    local.tags,
    {
      Name = format("%s_%s", var.env_prefix, lookup(each.value, "name"))
    }
  )

  lifecycle {
    prevent_destroy = false
  }
}