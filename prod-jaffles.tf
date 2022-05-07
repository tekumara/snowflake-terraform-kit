module "workspace-PROD_JAFFLES" {
  source = "./modules/workspace"
  providers = {
    snowflake.ACCOUNTADMIN  = snowflake.ACCOUNTADMIN
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  service_account = {
    user_name               = "PROD_JAFFLES_SA"
    user_role_grants        = []
    secret_reader_iam_roles = []
    secret_kms_key_id       = null
  }

  admin_role = {
    name           = "PROD_JAFFLES_ADMIN"
    grant_to_users = []
  }

  reader_role = {
    name           = "PROD_JAFFLES_READER"
    grant_to_roles = []
  }

  database = {
    name    = "PROD_JAFFLES"
    comment = "My jaffle shop (prod)"
  }

  warehouse = {
    name    = "PROD_JAFFLES_WH"
    comment = "Jaffle shop warehouse (prod)"
  }

  // TODO: no-op for now, see tags.tf
  tags = {
    pii = true
  }
}

// additional roles can be granted here
resource "snowflake_role" "example" {
  provider = snowflake.SECURITYADMIN
  name     = "EXAMPLE_ROLE"
}

resource "snowflake_role_grants" "example_grant_PROD_JAFFLES_SA" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.example.name

  users = [module.workspace-PROD_JAFFLES.user.name]
}

// can have many for the same role

resource "snowflake_role_grants" "example_grant_SYSADMIN" {
  provider  = snowflake.SECURITYADMIN
  role_name = snowflake_role.example.name
  roles     = ["SYSADMIN"]
}

