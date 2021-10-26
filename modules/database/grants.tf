// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html

locals {
  # granted to readers + admins
  read_privileges = {
    database = ["USAGE"]
    schema   = ["USAGE"]
    table    = ["SELECT", "REFERENCES"]
    view     = ["SELECT", "REFERENCES"]
  }
  # granted to admins only
  additional_admin_privileges = {
    database = ["CREATE SCHEMA"]
    schema = [
      "CREATE FUNCTION",
      "CREATE MATERIALIZED VIEW",
      "CREATE PROCEDURE",
      "CREATE SEQUENCE",
      "CREATE TABLE",
      # "CREATE TAG", TODO: see tags.tf
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

// apply read_privileges defined above to readers + admins

resource "snowflake_database_grant" "read_privileges" {
  for_each = toset(local.read_privileges.database)

  database_name = snowflake_database.db.name
  privilege     = each.key
  roles         = concat(var.readers, var.admins)
}

resource "snowflake_schema_grant" "read_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.read_privileges.schema)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = concat(var.readers, var.admins)
}

resource "snowflake_table_grant" "read_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.read_privileges.table)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = concat(var.readers, var.admins)
}

resource "snowflake_view_grant" "read_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.read_privileges.view)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = concat(var.readers, var.admins)
}

// apply additional_admin_privileges defined above to admins

resource "snowflake_database_grant" "additional_admin_privileges" {
  for_each = toset(local.additional_admin_privileges.database)

  database_name = snowflake_database.db.name
  privilege     = each.key
  roles         = var.admins
}


resource "snowflake_schema_grant" "additional_admin_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.additional_admin_privileges.schema)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.admins
}

resource "snowflake_table_grant" "additional_admin_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.additional_admin_privileges.table)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.admins
}

resource "snowflake_view_grant" "additional_admin_privileges" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.additional_admin_privileges.view)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.admins
}
