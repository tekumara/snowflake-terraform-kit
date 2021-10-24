terraform {
  required_providers {
    snowflake = {
      source = "chanzuckerberg/snowflake"
    }
  }
}

resource "snowflake_database" "db" {
  name    = local.database_name
  comment = var.comment
}
