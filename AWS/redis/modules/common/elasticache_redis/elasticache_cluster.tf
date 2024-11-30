resource "aws_elasticache_replication_group" "redis" {
  automatic_failover_enabled    = var.automatic_failover_enabled
  replication_group_id          = local.cluster_name
  description                   = "Redis cluster (${local.name})"
  engine                        = "redis"
  engine_version                = var.engine_version
  port                          = local.port
  node_type                     = var.node_type
  num_cache_clusters            = var.number_cache_clusters != null ? var.number_cache_clusters : null
  parameter_group_name          = var.parameter_group_name
  subnet_group_name             = aws_elasticache_subnet_group.private.name
  security_group_ids            = [aws_security_group.redis.id]
  maintenance_window            = var.maintenance_window
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  apply_immediately             = var.env != "production"
  multi_az_enabled              = var.multi_az_enabled
  tags                          = merge(local.base_tags, { Name = local.cluster_name })

  dynamic "cluster_mode" {
    for_each = var.cluster_options
    content {
      num_node_groups         = cluster_mode.value.num_node_groups
      replicas_per_node_group = cluster_mode.value.replicas_per_node_group
    }
  }
}
