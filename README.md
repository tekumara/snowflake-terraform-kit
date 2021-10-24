# Snowflake terraform kit

Modules for:

- [database](modules/database) creates a database and assigns reader and admin role grants to the passed in roles. Schemas and tables are managed by another application (eg: dbt) using the admin role.
- [warehouse](modules/warehouse) creates a warehouse and resource monitor and assigns role grants to the passed in role.

The [jaffle shop example](jaffles.tf) uses these modules to create production and development databases.

## Notes

All objects are owned by SYSADMIN.

chanzuckerberg/terraform-provider-snowflake [doesn't support ALL grants](https://github.com/chanzuckerberg/terraform-provider-snowflake/discussions/318) for good reason.

## See also

- [immuta/terraform-snowflake-fast-data-warehouse](https://github.com/immuta/terraform-snowflake-fast-data-warehouse) was the inspiration for this project. This project is a lean version of the immuta project, which has more feature eg: creating roles. immuta uses a single provider configuration, whereas this project makes the required roles (ACCOUNTADMIN, SECURITYADMIN etc.) explicit.
