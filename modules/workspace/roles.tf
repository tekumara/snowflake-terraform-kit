resource "snowflake_role" "admin" {
  provider = snowflake.SECURITYADMIN
  name     = upper(var.admin_role.name)
}

resource "snowflake_role_grants" "admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.admin.name

  roles = [
    "SYSADMIN",
  ]

  users = concat([snowflake_user.user.name], [for user in var.admin_role.grant_to_users : upper(user)])
}

resource "snowflake_role" "reader" {
  provider = snowflake.SECURITYADMIN
  count    = var.reader_role != null ? 1 : 0

  name = upper(var.reader_role.name)
}

resource "snowflake_role_grants" "reader" {
  provider  = snowflake.SECURITYADMIN
  count     = length(local.database_reader_roles) > 0 ? 1 : 0
  role_name = snowflake_role.reader[0].name

  roles = local.database_reader_roles
}
