module "workspace-PROD_JAFFLES" {
  source = "./modules/workspace"
  providers = {
    snowflake.ACCOUNTADMIN  = snowflake.ACCOUNTADMIN
    snowflake.SECURITYADMIN = snowflake.SECURITYADMIN
  }

  user_name              = "PROD_JAFFLES_SA"
  user_comment           = "Jaffle shop service account (prod)"
  secret_reader_iam_role = null
  secret_kms_key_id      = null

  role_name = "PROD_JAFFLES_ADMIN"

  database_name         = "PROD_JAFFLES"
  database_comment      = "My jaffle shop (prod)"
  database_reader_roles = []

  warehouse_name    = "PROD_JAFFLES_WH"
  warehouse_comment = "Jaffle shop warehouse (prod)"

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

