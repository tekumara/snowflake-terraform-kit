locals {
  // TODO: no-op for now, see tags.tf
  dev_jaffles = {
    tags = {
      pii = true
    }
  }
}

// service account user
module "service-account-DEV_JAFFLES_SA" {
  source = "./modules/service-account"
  providers = {
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name    = "DEV_JAFFLES_SA"
  comment = "Jaffle shop service account (dev)"
}


// role
resource "snowflake_role" "dev_jaffles_admin" {
  provider = snowflake.SECURITYADMIN
  name     = "DEV_JAFFLES_ADMIN"
}

resource "snowflake_role_grants" "dev_jaffles_admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.dev_jaffles_admin.name

  roles = [
    "SYSADMIN",
  ]

  users = [module.service-account-DEV_JAFFLES_SA.name]
}

// database
module "database-DEV_JAFFLES" {
  source = "./modules/database"
  providers = {
    snowflake               = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name         = "DEV_JAFFLES"
  comment      = "My jaffle shop (dev)"
  admin_roles  = [snowflake_role.dev_jaffles_admin.name]
  reader_roles = []
}

// warehouse + monitor
module "warehouse-DEV_JAFFLES_WH" {
  source = "./modules/warehouse"
  providers = {
    snowflake.ACCOUNTADMIN  = snowflake.ACCOUNTADMIN
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name            = "DEV_JAFFLES_WH"
  comment         = "Jaffle shop warehouse (dev)"
  warehouse_roles = [snowflake_role.dev_jaffles_admin.name]
}
