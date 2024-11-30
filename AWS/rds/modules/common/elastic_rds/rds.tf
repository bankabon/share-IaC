resource "aws_db_instance" "master" {
  identifier                            = var.identifier
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  apply_immediately                     = var.env != "production"
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  ca_cert_identifier                    = var.ca_cert_identifier
  db_name                               = var.db_name
  db_subnet_group_name                  = aws_db_subnet_group.private.name
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_class
  kms_key_id                            = var.kms_key_id
  multi_az                              = var.multi_az
  maintenance_window                    = var.maintenance_window  
  skip_final_snapshot                   = var.skip_final_snapshot
  option_group_name                     = var.option_group_name
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  port                                  = local.port
  parameter_group_name                  = var.parameter_group_name
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  username                              = var.username
  password                              = var.password
  vpc_security_group_ids                = [aws_security_group.rds.id]
  monitoring_role_arn = var.env_short == "prod" ? aws_iam_role.enhanced_monitoring[0].arn : ""
  monitoring_interval = var.env_short == "prod" ? 60 : 0
  tags                                   = merge(local.base_tags, { Name = local.name })
}

/* RDSのreplicaを作成したい場合は、以下をコメントインしてください
resource "aws_db_instance" "replica" {
  identifier                            = "${var.identifier}-replica"
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  apply_immediately                     = var.env != "production"
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  ca_cert_identifier                    = var.ca_cert_identifier
  instance_class                        = var.instance_class
  iops                                  = var.iops
  kms_key_id                            = var.kms_key_id
  multi_az                              = var.multi_az
  maintenance_window                    = var.maintenance_window  
  skip_final_snapshot                   = var.skip_final_snapshot
  option_group_name                     = var.option_group_name
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  port                                  = local.port
  parameter_group_name                  = var.parameter_group_name
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  password                              = var.password
  replicate_source_db                   = aws_db_instance.master.id
  vpc_security_group_ids                = [aws_security_group.rds.id]
  monitoring_role_arn = var.env_short == "prod" ? aws_iam_role.enhanced_monitoring[0].arn : ""
  monitoring_interval = var.env_short == "prod" ? 60 : 0
  tags                                   = merge(local.base_tags, { Name = local.name })
}
*/