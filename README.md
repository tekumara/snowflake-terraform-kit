# Snowflake terraform kit

A [jaffle shop example](jaffles.tf) that uses these modules:

- [database](modules/database) creates a database and assigns reader and admin role grants to the passed in roles. Schemas and tables are managed by another application (eg: dbt) using the admin role.
- [warehouse](modules/warehouse) creates a warehouse and resource monitor and assigns role grants to the passed in role.

All objects are owned by SYSADMIN.

## Notes

chanzuckerberg/terraform-provider-snowflake [doesn't support ALL grants](https://github.com/chanzuckerberg/terraform-provider-snowflake/discussions/318) for good reason.

## See also

- [immuta/terraform-snowflake-fast-data-warehouse](https://github.com/immuta/terraform-snowflake-fast-data-warehouse) was the inspiration for this project. The immuta projects differs by creating roles within the same module, and uses a single provider configuration.
