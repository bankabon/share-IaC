module "corp_redis" {
  source = "../../modules/redis"

  env       = "test"
  env_short = "test"
  env_type  = "test"
  domain    = "bankabon.jp"

  cluster_name               = "peech-redis"
  security_group_name        = "all-redis"
  security_group_description = "open all port"
  subnet_group_name          = "bankabon-redis-subnet"
  subnet_type                = "cache"

  automatic_failover_enabled = false
  engine_version             = "2.6.13"
  parameter_group_name       = "default.redis2.6"
  node_type                  = "cache.t3.medium"
  number_cache_clusters      = 1
  maintenance_window         = "fri:20:00-fri:21:00"
  snapshot_retention_limit   = 0
  snapshot_window            = "21:00-22:00"

  allowed_roles = [
    "web_ec2_all"
  ]
}
