locals {
  name       = format("%s_%s_%s", var.env_type, var.service, var.role)
  name_kebab = replace(local.name, "_", "-")
  port       = 3306
  vpc_id     = "vpc-0039ef39ca93fe5ce"

  security_group_name        = var.security_group_name != null ? var.security_group_name : local.name
  security_group_description = var.security_group_description != null ? var.security_group_description : " RDS (${local.name})"
  subnet_group_name          = var.subnet_group_name != null ? var.subnet_group_name : local.name_kebab
  subnet_type                = var.subnet_type != null ? var.subnet_type : "rds"

  env_short_for_subnet = var.env_short == "rc" ? "prod" : var.env_short

  base_tags = {
    Service = var.service
    Env     = var.env
    Domain  = var.domain
  }
}
