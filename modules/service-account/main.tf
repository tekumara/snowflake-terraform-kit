terraform {
  required_providers {
    snowflake = {
      source                = "chanzuckerberg/snowflake"
      configuration_aliases = [snowflake.SECURITYADMIN]
    }
    aws = {}
  }
}

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "user" {
  provider = snowflake.SECURITYADMIN
  name     = local.name
  comment  = var.comment
  # strip out the pem header and footer
  rsa_public_key = substr(
    tls_private_key.keypair.public_key_pem,
    27,
    398
  )
}

resource "aws_secretsmanager_secret" "snowflake_user_private_key" {
  name        = "snowflake.user.privatekey.${snowflake_user.user.name}"
  description = "Snowflake user private key"

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

resource "aws_secretsmanager_secret_version" "privatekey" {
  secret_id = aws_secretsmanager_secret.snowflake_user_private_key.id
  # strip out the pem header and footer
  secret_string = substr(
    tls_private_key.keypair.private_key_pem,
    32,
    1616
  )
}
