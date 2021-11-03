locals {
  // TODO: no-op for now, see tags.tf
  prod_jaffles_tags = {
    pii = true
  }
}

// service account user
module "service-account-PROD_JAFFLES_SA" {
  source = "./modules/service-account"
  providers = {
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name    = "PROD_JAFFLES_SA"
  comment = "Jaffle shop service account (prod)"
}


// role
resource "snowflake_role" "prod_jaffles_admin" {
  provider = snowflake.SECURITYADMIN
  name     = "PROD_JAFFLES_ADMIN"
}

resource "snowflake_role_grants" "prod_jaffles_admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.prod_jaffles_admin.name

  roles = [
    "SYSADMIN",
  ]

  users = [module.service-account-PROD_JAFFLES_SA.name]
}

// database
module "database-PROD_JAFFLES" {
  source = "./modules/database"
  providers = {
    snowflake               = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name         = "PROD_JAFFLES"
  comment      = "My jaffle shop (prod)"
  admin_roles  = [snowflake_role.prod_jaffles_admin.name]
  reader_roles = []
}

// warehouse + monitor
module "warehouse-PROD_JAFFLES_WH" {
  source = "./modules/warehouse"
  providers = {
    snowflake.ACCOUNTADMIN  = snowflake.ACCOUNTADMIN
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name            = "PROD_JAFFLES_WH"
  comment         = "Jaffle shop warehouse (prod)"
  warehouse_roles = [snowflake_role.prod_jaffles_admin.name]
}
