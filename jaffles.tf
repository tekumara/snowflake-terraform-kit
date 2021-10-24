// roles
resource "snowflake_role" "jaffles_admin" {
  provider = snowflake.SECURITYADMIN
  name     = "JAFFLES_ADMIN"
}

resource "snowflake_role" "jaffles_reader" {
  provider = snowflake.SECURITYADMIN
  name     = "JAFFLES_READER"
}

// databases
module "databases" {
  source        = "./modules/database"
  providers = {
    snowflake = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  database_name = each.key
  comment       = each.value.comment
  admins        = each.value.admins
  readers       = each.value.readers

  for_each = {
    "PROD_JAFFLES" = {
      comment = "My jaffle shop (prod)"
      tags = {
        // TODO: no-op for now, see tags.tf
        pii         = true
      }
      admins  = [snowflake_role.jaffles_admin.name]
      readers = [snowflake_role.jaffles_reader.name]
    }
    "DEV_JAFFLES" = {
      comment = "My jaffle shop (dev)"
      tags = {
        // TODO: no-op for now, see tags.tf
        pii         = true
      }
      admins  = [snowflake_role.jaffles_admin.name]
      readers = [snowflake_role.jaffles_reader.name]
    }
  }
}
