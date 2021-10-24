// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html

locals {
  reader_privileges = {
    database = ["USAGE"]
    schema   = ["USAGE"]
    table    = ["SELECT", "REFERENCES"]
    view     = ["SELECT", "REFERENCES"]
  }
  admin_privileges = {
    database = concat(local.reader_privileges.database, [
      "CREATE SCHEMA",
    ])
    schema = concat(local.reader_privileges.schema, [
      "CREATE FUNCTION",
      "CREATE MATERIALIZED VIEW",
      "CREATE PROCEDURE",
      "CREATE SEQUENCE",
      "CREATE TABLE",
      # "CREATE TAG", TODO: see tags.tf
      "CREATE VIEW",
      "MODIFY",
      "MONITOR",
    ])
    table = concat(local.reader_privileges.table, [
      "DELETE",
      "INSERT",
      "TRUNCATE",
      "UPDATE",
    ])
    view = local.reader_privileges.view
  }
}

// apply reader grants defined above

resource "snowflake_database_grant" "reader" {
  for_each = toset(local.reader_privileges.database)

  database_name = snowflake_database.db.name
  privilege     = each.key
  roles         = var.readers
}

resource "snowflake_schema_grant" "reader" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.reader_privileges.schema)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.readers
}

resource "snowflake_table_grant" "reader" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.reader_privileges.table)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.readers
}

resource "snowflake_view_grant" "reader" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.reader_privileges.view)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.readers
}

// apply admin grants defined above

resource "snowflake_database_grant" "admin" {
  for_each = toset(local.admin_privileges.database)

  database_name = snowflake_database.db.name
  privilege     = each.key
  roles         = var.admins
}


resource "snowflake_schema_grant" "admin" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.admin_privileges.schema)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.admins
}

resource "snowflake_table_grant" "admin" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.admin_privileges.table)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.admins
}

resource "snowflake_view_grant" "admin" {
  provider = snowflake.SECURITYADMIN
  for_each = toset(local.admin_privileges.view)

  database_name = snowflake_database.db.name
  on_future     = true
  privilege     = each.key
  roles         = var.admins
}
