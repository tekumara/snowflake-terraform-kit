locals {
  // TODO: no-op for now, see tags.tf
  tags = {
    pii = true
  }
}

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
      tags    = local.tags
      admins  = [snowflake_role.jaffles_admin.name]
      readers = [snowflake_role.jaffles_reader.name]
    }
    "DEV_JAFFLES" = {
      comment = "My jaffle shop (dev)"
      tags    = local.tags
      admins  = [snowflake_role.jaffles_admin.name]
      readers = []
    }
  }
}

// warehouses + monitors
module "warehouses" {
  source = "./modules/warehouse"
  providers = {
    snowflake              = snowflake
    snowflake.ACCOUNTADMIN = snowflake.ACCOUNTADMIN
  }

  name    = each.key
  comment = each.value.comment

  for_each = {
    "PROD_JAFFLES_WH" = {
      comment         = "Jaffle shop warehouse (prod)"
      tags            = local.tags
      warehouse_roles = [snowflake_role.jaffles_admin.name]
    }
    "DEV_JAFFLES_WH" = {
      comment         = "Jaffle shop warehouse (dev)"
      tags            = local.tags
      warehouse_roles = [snowflake_role.jaffles_admin.name]
    }
  }
}
