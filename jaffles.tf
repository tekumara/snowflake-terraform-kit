// roles
resource "snowflake_role" "jaffles_admin" {
  name = "JAFFLES_ADMIN"
}

resource "snowflake_role" "jaffles_reader" {
  name = "JAFFLES_READER"
}

// databases
module "databases" {
  source        = "./modules/product_database"
  database_name = each.key
  comment       = each.value.comment
  admins        = each.value.admins
  readers       = each.value.readers

  for_each = {
    "PROD_JAFFLES" = {
      comment = "My jaffle shop (prod)"
      tags = {
        // TODO: terraform metadata only
        dbt_managed = true
        pii         = true
      }
      admins  = [snowflake_role.jaffles_admin.name]
      readers = [snowflake_role.jaffles_reader.name]
    }
    "DEV_JAFFLES" = {
      comment = "My jaffle shop (dev)"
      tags = {
        // TODO: terraform metadata only
        dbt_managed = true
        pii         = true
      }
      admins  = [snowflake_role.jaffles_admin.name]
      readers = [snowflake_role.jaffles_reader.name]
    }
  }
}
