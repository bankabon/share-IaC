module "corp_rds" {
  source = "../../modules/bankabonrds"

  env       = "test"
  env_short = "test"
  env_type  = "test"
  domain    = "<domain>"

  security_group_name        = "all-rds"
  security_group_description = "open all port"
  subnet_group_name          = "<subnet name>"
  subnet_type                = "rds"

  identifier                            = "<name>"
  allocated_storage                     = 100
  max_allocated_storage                 = 500
  backup_retention_period               = "7"
  backup_window                         = "17:45-18:15"
  ca_cert_identifier                    = "rds-ca-2019"
  db_name                               = "bankabontest"
  engine                                = "mysql"
  engine_version                        = "8.0.28"
  instance_class                        = "db.t3.micro"
  iops                                  = 3000
  kms_key_id                            = "<kms key>"
  multi_az                              = "true"
  maintenance_window                    = "fri:20:00-fri:21:00"  
  skip_final_snapshot                   = true
  option_group_name                     = "default:mysql-8-0"
  performance_insights_enabled          = "false"
  performance_insights_retention_period = "0"
  parameter_group_name                  = "default.mysql8.0"
  storage_encrypted                     = "true"
  storage_type                          = "gp2"
  copy_tags_to_snapshot                 = "true"
  db_username                           = "admin"

  allowed_roles = [
    "web_ec2_all"
  ]
}
