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
      "CREATE TAG",
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

// apply the grants defined above

resource "snowflake_database_grant" "reader" {
  for_each = toset(local.reader_privileges.database)

  database_name = snowflake_database.db.name
  privilege     = each.key
  roles         = var.readers
}

