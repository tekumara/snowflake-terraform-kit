# Snowflake terraform kit

A [jaffle shop example](jaffles.tf) that uses these modules:

- [database](modules/database) which assigns grants to reader and admin roles. Schemas and tables are managed by another application (eg: dbt) using the admin role.

All objects are owned by SYSADMIN.

## Notes

chanzuckerberg/terraform-provider-snowflake [doesn't support ALL grants](https://github.com/chanzuckerberg/terraform-provider-snowflake/discussions/318) for good reason.

## See also

- [immuta/terraform-snowflake-fast-data-warehouse](https://github.com/immuta/terraform-snowflake-fast-data-warehouse) was the inspiration for this project, but it creates roles and warehouses all within the same module.
