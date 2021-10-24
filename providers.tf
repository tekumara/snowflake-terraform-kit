# Snowflake Providers
provider "snowflake" {
  username  = var.snowflake_username
  account   = var.snowflake_account
  region    = var.snowflake_region

  role      = "ACCOUNTADMIN"
}

provider "snowflake" {
  username  = var.snowflake_username
  account   = var.snowflake_account
  region    = var.snowflake_region

  alias     = "SYSADMIN"
  role      = "SYSADMIN"
}

provider "snowflake" {
  username  = var.snowflake_username
  account   = var.snowflake_account
  region    = var.snowflake_region

  alias     = "SECURITYADMIN"
  role      = "SECURITYADMIN"
}
