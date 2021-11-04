resource "snowflake_user" "user" {
  provider = snowflake.SECURITYADMIN
  name     = local.user_name
  comment  = var.user_comment
  // password set by the secret
}
