module "rds_mysql" {
  source = "../../modules/common/elastic_rds"

  service   = local.service
  env       = var.env
  env_short = var.env_short
  env_type  = var.env_type
  domain    = var.domain
  role      = "bankabonrds"

  security_group_name        = var.security_group_name
  security_group_description = var.security_group_description
  subnet_group_name          = var.subnet_group_name
  subnet_type                = var.subnet_type

  identifier                            = var.identifier
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  ca_cert_identifier                    = var.ca_cert_identifier
  db_name                               = var.db_name
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
  parameter_group_name                  = var.parameter_group_name
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  username                              = var.db_username
  password                              = data.aws_secretsmanager_secret_version.db-password.secret_string

  allowed_security_group_ids = {
    for role in var.allowed_roles :
    role => data.aws_security_group.roles[role].id
  }
}
