// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html

locals {
  # granted to reader_role + admin_role
  read_privileges = {
    database = ["USAGE"]
    schema   = ["USAGE"]
    table    = ["SELECT", "REFERENCES"]
    view     = ["SELECT", "REFERENCES"]
  }
  # granted to admin_role only
  additional_admin_privileges = {
    database = ["CREATE SCHEMA"]
    schema = [
      "CREATE EXTERNAL TABLE",
      "CREATE FILE FORMAT",
      "CREATE FUNCTION",
      "CREATE MASKING POLICY",
      "CREATE MATERIALIZED VIEW",
      "CREATE PIPE",
      "CREATE PROCEDURE",
      "CREATE ROW ACCESS POLICY",
      "CREATE SEQUENCE",
      "CREATE STAGE",
      "CREATE STREAM",
      "CREATE TABLE",
      # TODO: waiting for https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/734
      # "CREATE TAG",
      "CREATE TASK",
      "CREATE VIEW",
      "MODIFY",
      "MONITOR",
    ]
    table = [
      "DELETE",
      "INSERT",
      "TRUNCATE",
      "UPDATE",
    ]
    view = []
  }
}

// apply read_privileges defined above to reader_role + admin_role

resource "snowflake_database_grant" "read_privileges" {
  for_each = toset(local.read_privileges.database)

  database_name = snowflake_database.db.name
  privilege     = each.key
  roles         = compact([var.reader_role, var.admin_role])
}

resource "snowflake_schema_grant" "read_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.read_privileges.schema)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = compact([var.reader_role, var.admin_role])
}

resource "snowflake_table_grant" "read_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.read_privileges.table)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = compact([var.reader_role, var.admin_role])
}

resource "snowflake_view_grant" "read_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.read_privileges.view)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = compact([var.reader_role, var.admin_role])
}

// apply additional_admin_privileges defined above to admin_role

resource "snowflake_database_grant" "additional_admin_privileges" {
  for_each = toset(local.additional_admin_privileges.database)

  database_name = snowflake_database.db.name
  privilege     = each.key
  roles         = compact([var.admin_role])
}


resource "snowflake_schema_grant" "additional_admin_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.additional_admin_privileges.schema)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = compact([var.admin_role])
}

resource "snowflake_table_grant" "additional_admin_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.additional_admin_privileges.table)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = compact([var.admin_role])
}

resource "snowflake_view_grant" "additional_admin_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.additional_admin_privileges.view)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = compact([var.admin_role])
}
