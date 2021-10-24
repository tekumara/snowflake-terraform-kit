terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "~> 0.25.22"
    }
  }
  required_version = ">= 1.0"
}

# Snowflake Providers
provider "snowflake" {
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = var.snowflake_region

  role = "SYSADMIN"
}

provider "snowflake" {
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = var.snowflake_region

  alias = "SECURITYADMIN"
  role  = "SECURITYADMIN"
}
