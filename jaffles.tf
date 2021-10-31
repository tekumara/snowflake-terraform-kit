locals {
  // TODO: no-op for now, see tags.tf
  tags = {
    pii = true
  }
}

// roles
resource "snowflake_role" "prod_jaffles_admin" {
  provider = snowflake.SECURITYADMIN
  name     = "PROD_JAFFLES_ADMIN"
}

resource "snowflake_role" "dev_jaffles_admin" {
  provider = snowflake.SECURITYADMIN
  name     = "DEV_JAFFLES_ADMIN"
}

resource "snowflake_role" "jaffles_reader" {
  provider = snowflake.SECURITYADMIN
  name     = "JAFFLES_READER"
}

resource "snowflake_role_grants" "prod_jaffles_admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.prod_jaffles_admin.name

  roles = [
    "SYSADMIN",
  ]

  users = []
}

resource "snowflake_role_grants" "dev_jaffles_admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.dev_jaffles_admin.name

  roles = [
    "SYSADMIN",
  ]

  users = []
}

// databases
module "databases" {
  source = "./modules/database"
  providers = {
    snowflake               = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name        = each.key
  comment     = each.value.comment
  admin_role  = each.value.admin_role
  reader_role = each.value.reader_role

  for_each = {
    "PROD_JAFFLES" = {
      comment     = "My jaffle shop (prod)"
      tags        = local.tags
      admin_role  = snowflake_role.prod_jaffles_admin.name
      reader_role = snowflake_role.jaffles_reader.name
    }
    "DEV_JAFFLES" = {
      comment     = "My jaffle shop (dev)"
      tags        = local.tags
      admin_role  = snowflake_role.dev_jaffles_admin.name
      reader_role = ""
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

  name            = each.key
  comment         = each.value.comment
  warehouse_role = each.value.warehouse_role

  for_each = {
    "PROD_JAFFLES_WH" = {
      comment         = "Jaffle shop warehouse (prod)"
      tags            = local.tags
      warehouse_role = snowflake_role.prod_jaffles_admin.name
    }
    "DEV_JAFFLES_WH" = {
      comment         = "Jaffle shop warehouse (dev)"
      tags            = local.tags
      warehouse_role = snowflake_role.dev_jaffles_admin.name
    }
  }
}
