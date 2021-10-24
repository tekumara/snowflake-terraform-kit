terraform {
  required_providers {
    snowflake = {
      source = "chanzuckerberg/snowflake"
      configuration_aliases = [ snowflake.SECURITYADMIN ]
    }
  }
}

resource "snowflake_database" "db" {
  name    = local.name
  comment = var.comment
}
