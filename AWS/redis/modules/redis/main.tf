module "elasticache_redis" {
  source = "../../modules/common/elasticache_redis"

  service   = local.service
  env       = var.env
  env_short = var.env_short
  env_type  = var.env_type
  domain    = var.domain
  role      = "bankabonredis"

  cluster_name               = var.cluster_name
  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  subnet_group_name          = var.subnet_group_name
  subnet_type                = var.subnet_type

  automatic_failover_enabled = var.automatic_failover_enabled
  engine_version             = var.engine_version
  parameter_group_name       = var.parameter_group_name
  node_type                  = var.node_type
  number_cache_clusters      = var.number_cache_clusters
  maintenance_window         = var.maintenance_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window

  allowed_security_group_ids = {
    for role in var.allowed_roles :
    role => data.aws_security_group.roles[role].id
  }
}
