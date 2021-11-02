locals {
  // TODO: no-op for now, see tags.tf
  tags = {
    pii = true
  }
}

// service account users
module "user" {
  source = "./modules/user"
  providers = {
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name    = each.key
  comment = each.value.comment

  for_each = {
    "PROD_JAFFLES_SA" = {
      comment = "Jaffle shop service account (prod)"
      tags    = local.tags
    }
    "DEV_JAFFLES_SA" = {
      comment = "Jaffle shop service account (dev)"
      tags    = local.tags
    }
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

  users = [module.user["PROD_JAFFLES_SA"].name]
}

resource "snowflake_role_grants" "dev_jaffles_admin" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.dev_jaffles_admin.name

  roles = [
    "SYSADMIN",
  ]

  users = [module.user["DEV_JAFFLES_SA"].name]
}

// databases
module "databases" {
  source = "./modules/database"
  providers = {
    snowflake               = snowflake
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  name         = each.key
  comment      = each.value.comment
  admin_roles  = each.value.admin_roles
  reader_roles = each.value.reader_roles

  for_each = {
    "PROD_JAFFLES" = {
      comment      = "My jaffle shop (prod)"
      tags         = local.tags
      admin_roles  = [snowflake_role.prod_jaffles_admin.name]
      reader_roles = [snowflake_role.jaffles_reader.name]
    }
    "DEV_JAFFLES" = {
      comment      = "My jaffle shop (dev)"
      tags         = local.tags
      admin_roles  = [snowflake_role.dev_jaffles_admin.name]
      reader_roles = []
    }
  }
}

// warehouses + monitors
module "warehouses" {
  source = "./modules/warehouse"
  providers = {
    snowflake.ACCOUNTADMIN = snowflake.ACCOUNTADMIN
  }

  name            = each.key
  comment         = each.value.comment
  warehouse_roles = each.value.warehouse_roles

  for_each = {
    "PROD_JAFFLES_WH" = {
      comment         = "Jaffle shop warehouse (prod)"
      tags            = local.tags
      warehouse_roles = [snowflake_role.prod_jaffles_admin.name]
    }
    "DEV_JAFFLES_WH" = {
      comment         = "Jaffle shop warehouse (dev)"
      tags            = local.tags
      warehouse_roles = [snowflake_role.dev_jaffles_admin.name]
    }
  }
}
