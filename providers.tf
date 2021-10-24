# Snowflake Providers
provider "snowflake" {
  username  = var.snowflake_username
  account   = var.snowflake_account
  region    = var.snowflake_region

  role      = "SYSADMIN"
}

provider "snowflake" {
  username  = var.snowflake_username
  account   = var.snowflake_account
  region    = var.snowflake_region

  alias     = "SECURITYADMIN"
  role      = "SECURITYADMIN"
}
