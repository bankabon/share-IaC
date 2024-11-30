resource "random_password" "db-password" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db-password" {
  name = "${local.service}-db-password"
}

resource "aws_secretsmanager_secret_version" "db-password" {
  secret_id     = aws_secretsmanager_secret.db-password.id
  secret_string = random_password.db-password.result
}

data "aws_secretsmanager_secret" "db-password" {
  name       = "${local.service}-db-password"
  depends_on = [aws_secretsmanager_secret.db-password]
}

data "aws_secretsmanager_secret_version" "db-password" {
  secret_id  = data.aws_secretsmanager_secret.db-password.id
  depends_on = [aws_secretsmanager_secret_version.db-password]
}