module "databases" {
  source = "./modules/product_database"
  database_name = "${each.key}"
  for_each = {
    "PROD_JAFFLES" = {
      comment = "My jaffle shop (prod)"
      readers = []
      admins = []
      tags = {
        dbt_managed = true
      }
    }
    "DEV_JAFFLES" = {
      comment = "My jaffle shop (dev)"
      readers = []
      admins = []
      tags = {
        dbt_managed = true
      }
    }
  }

}
