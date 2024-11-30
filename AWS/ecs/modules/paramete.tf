resource "aws_ssm_parameter" "paramete-state" {
  name  = var.paramate_name
  type  = var.paramate_type
  value = var.paramate_value
}