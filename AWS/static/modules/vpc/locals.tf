locals {
  service = var.env_name

 public_subnets     = keys(var.public_subnet_cidrs)
 private_subnets    = keys(var.private_subnet_cidrs)
 public_alb_subnets = keys(var.public_subnet_alb_cidrs)

  tags = {
    Service = local.service
    Env     = var.environment
  }
}
