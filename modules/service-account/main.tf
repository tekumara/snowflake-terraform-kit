terraform {
  required_providers {
    snowflake = {
      source                = "chanzuckerberg/snowflake"
      configuration_aliases = [snowflake.SECURITYADMIN]
    }
    aws = {}
  }
}

resource "snowflake_user" "user" {
  provider = snowflake.SECURITYADMIN
  name     = local.name
  comment  = var.comment
  // password set below
}

data "snowflake_current_account" "this" {}

resource "aws_secretsmanager_secret" "snowflake_user" {
  name        = "snowflakeuser/${snowflake_user.user.name}"
  description = "Snowflake user password"

  policy = var.secret_reader_iam_role == null ? null : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CrossAccountRead"
        Effect = "Allow"
        Principal = {
          AWS = var.secret_reader_iam_role
        }
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = "*"
      }
    ]
  })

  // force delete, so we can recreate the secret immediately if needed
  recovery_window_in_days = 0

  kms_key_id = var.secret_kms_key_id
}

resource "null_resource" "set-password" {
  triggers = {
    secret_name = aws_secretsmanager_secret.snowflake_user.name
  }

  // set password for snowflake user and store it in the Secrets Manager secret
  // this is done in local-exec so it's not stored in the tf statefile
  provisioner "local-exec" {
    # see https://github.com/tekumara/sfpassman
    command = "sfpassman ${snowflake_user.user.name} ${aws_secretsmanager_secret.snowflake_user.name} $SNOWFLAKE_USER ${data.snowflake_current_account.this.account} $SNOWFLAKE_REGION"
  }
}
