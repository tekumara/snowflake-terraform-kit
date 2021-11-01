terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "~> 0.25.23"
    }
    snowsql = {
      source  = "aidanmelen/snowsql"
      version = ">= 0.1.0"
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

provider "snowflake" {
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = var.snowflake_region

  alias = "ACCOUNTADMIN"
  role  = "ACCOUNTADMIN"
}

provider "snowsql" {
  username = var.snowflake_username
  account  = var.snowflake_account
  region   = var.snowflake_region

  role = "SECURITYADMIN"
}
