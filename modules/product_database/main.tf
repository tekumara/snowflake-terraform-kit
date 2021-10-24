terraform {
  required_providers {
    snowflake = {
      source = "chanzuckerberg/snowflake"
    }
  }
}


// product database
resource "snowflake_database" "db" {
  name    = local.database_name
  comment = var.comment
}
