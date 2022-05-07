data "snowflake_current_account" "this" {}

resource "aws_secretsmanager_secret" "snowflake_user" {
  name        = "snowflake.user.password.${lower(snowflake_user.user.name)}"
  description = "Snowflake user password"

  policy = length(coalesce(var.service_account.secret_reader_iam_roles, [])) == 0 ? null : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "CrossAccountRead"
        Effect = "Allow"
        Principal = {
          AWS = var.service_account.secret_reader_iam_roles
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

  kms_key_id = var.service_account.secret_kms_key_id
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
