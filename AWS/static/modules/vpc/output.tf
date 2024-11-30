output "vpc_id" {
  value = aws_vpc.bankabon-test.id
}

output "public_subnet_ids" {
  value = [
    for v in aws_subnet.public : v.id
  ]
}

output "private_subnet_ids" {
  value = [
    for v in aws_subnet.private : v.id
  ]
}

output "public_nat_ids" {
  value = [
    for v in aws_subnet.public_nat : v.id
  ]
}

output "public_alb_ids" {
  value = [
    for v in aws_subnet.public_alb : v.id
  ]
}

output "route_table_id" {
  value = aws_route_table.public_nat.id
}

output "vpc_cidr" {
  value = aws_vpc.bankabon-test.cidr_block
}

// albおよびprivate nat不要のためコメントアウト
/*
output "public_alb_ids" {
  value = [
    for v in aws_subnet.alb : v.id
  ]
}

 output "private_nat_ids" {
   value = [
     for v in aws_subnet.nat : v.id
   ]
 }
 */