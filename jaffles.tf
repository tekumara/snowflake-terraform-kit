module "databases" {
  source = "./modules/product_database"
  database_name = "${each.key}"
  for_each = {
    "PROD_JAFFLES" = {
      comment = "My jaffle shop (prod)"
      readers = []
      admins = []
      # metadata only, TODO: apply these when https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/702 lands
      tags = {
        dbt_managed = true
      }
    }
    "DEV_JAFFLES" = {
      comment = "My jaffle shop (dev)"
      readers = []
      admins = []
      # metadata only, TODO: apply these when https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/702 lands
      tags = {
        dbt_managed = true
      }
    }
  }

}
