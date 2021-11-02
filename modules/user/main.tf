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
  provider  = snowflake.SECURITYADMIN
  name = local.name
  comment = var.comment

  // set password in local-exec so its not stored in the tf statefile
  provisioner "local-exec" {
      command = "echo 'TODO: SET PASSWORD FOR ${self.name}'"
  }
}

resource "aws_secretsmanager_secret" "snowflake_user" {
  depends_on = [
    snowflake_user.user
  ]
  name = "snowflakeuser/${snowflake_user.user.name}"
  description = "Snowflake user password"
}
