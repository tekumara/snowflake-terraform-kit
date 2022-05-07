resource "snowflake_user" "user" {
  provider = snowflake.SECURITYADMIN
  name     = upper(var.service_account.user_name)
  comment  = "workspace service account"
  // password set by the secret
}

resource "snowflake_role_grants" "user_role_grants" {
  provider = snowflake.SECURITYADMIN

  for_each  = toset(coalesce(var.service_account.user_role_grants, []))
  role_name = each.value

  users = [snowflake_user.user.name]
}
