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
  source = "./modules/database"
  providers = {
    snowflake               = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name    = each.key
  comment = each.value.comment
  admins  = each.value.admins
  readers = each.value.readers

  for_each = {
    "PROD_JAFFLES" = {
      comment = "My jaffle shop (prod)"
      // TODO: no-op for now, see tags.tf
      tags = {
        pii = true
      }
      admins  = [snowflake_role.jaffles_admin.name]
      readers = [snowflake_role.jaffles_reader.name]
    }
    "DEV_JAFFLES" = {
      comment = "My jaffle shop (dev)"
      // TODO: no-op for now, see tags.tf
      tags = {
        pii = true
      }
      admins  = [snowflake_role.jaffles_admin.name]
      readers = []
    }
  }
}

// warehouses + monitors
module "warehouses" {
  source = "./modules/warehouse"
  providers = {
    snowflake               = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name    = each.key
  comment = each.value.comment

  for_each = {
    "PROD_JAFFLES_WH" = {
      comment = "Jaffle shop warehouse (prod)"

    }
    "DEV_JAFFLES_WH" = {
      comment = "Jaffle shop warehouse (dev)"
    }
  }
}
