resource "aws_secretsmanager_secret" "newrelic" {
  name = var.paramate_name
}

resource "aws_secretsmanager_secret_version" "newrelic" {
  secret_id     = aws_secretsmanager_secret.newrelic.id
  secret_string = jsonencode(var.paramate_value)
}