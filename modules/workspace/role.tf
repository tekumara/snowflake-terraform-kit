resource "snowflake_role" "admin" {
  provider = snowflake.SECURITYADMIN
  name     = local.role_name
}

resource "snowflake_role_grants" "admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.admin.name

  roles = [
    "SYSADMIN",
  ]

  users = [snowflake_user.user.name]
}
