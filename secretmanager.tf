resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "db_password_secret" {
  name        = var.secret_name
  description = "Auto-generated database password stored securely for RDS instance"

  kms_key_id = aws_kms_key.db_password_key.arn

  tags = {
    Name        = "DatabasePassword"
    Environment = "production"
  }
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = aws_secretsmanager_secret.db_password_secret.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}

resource "aws_secretsmanager_secret" "user_creation_lambda_secrets" {
  name        = var.user_creation_secret_name
  description = "Secrets for user creation Lambda function"

  kms_key_id = aws_kms_key.db_password_key.id

  tags = {
    "Environment" = "production"
  }
}

resource "aws_secretsmanager_secret_version" "user_creation_lambda_secrets_version" {
  secret_id = aws_secretsmanager_secret.user_creation_lambda_secrets.id
  secret_string = jsonencode({
    SENDGRID_API_KEY  = var.sendgrid_api_key
    DATABASE_NAME     = var.DB_NAME
    DATABASE_USERNAME = var.DB_USERNAME
    DATABASE_PASSWORD = jsondecode(aws_secretsmanager_secret_version.db_password_version.secret_string).password
    DATABASE_HOST     = element(split(":", aws_db_instance.rds_instance.endpoint), 0),
    DOMAIN            = var.domain_name
    SNS_TOPIC_ARN     = aws_sns_topic.user_creation_topic.arn
  })
}
