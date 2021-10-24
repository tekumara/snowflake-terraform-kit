terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "~> 0.25.22"
    }
  }
  required_version = ">= 1.0"
}
