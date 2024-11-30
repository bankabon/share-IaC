// vpc用
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_nat_ids" {
  value = module.vpc.public_nat_ids
}

output "public_alb_ids" {
  value = module.vpc.public_alb_ids
}

// natインスタンス用
output "nat_instance_id" {
  value = module.ec2.instance_id
}

output "nat_security_group" {
  value = module.ec2.security_group_id
}