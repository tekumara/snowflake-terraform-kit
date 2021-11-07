# Snowflake terraform kit

Modules for:

- [database](modules/database) creates a database and assigns reader and admin role grants to the passed in roles. Schemas and tables are managed by another application (eg: dbt) using the admin role.
- [warehouse](modules/warehouse) creates a warehouse and resource monitor and assigns role grants to the passed in role.
- [service-account](modules/service-account) creates a Snowflake user and AWS Secrets Manager secret to hold the password.
- [workspace](modules/workspace) creates all of the above: a database, warehouse, user, secret plus a role.

Examples:

- Jaffle shop [production](prod-jaffles.tf) using the domain module.
- Jaffle shop [development](dev-jaffles.tf) using the individual modules.

## Usage

Create an _account.tfvars_ file:

```
snowflake_account  = "JAFFLE_KING"
snowflake_username = "alice"
snowflake_region   = "ap-southeast-2"
```

Set your password as an environment variable:

```
export SNOWFLAKE_PASSWORD=topsecret
```

Create the [example](jaffles.tf) terraform plan:

```
terraform apply -var-file account.tfvars
```

## Notes

All objects are owned by SYSADMIN.

chanzuckerberg/terraform-provider-snowflake [doesn't support ALL grants](https://github.com/chanzuckerberg/terraform-provider-snowflake/discussions/318) for good reason.

snowflake_role_grants will only manage its own grants. There can be multiple snowflake_role_grants for the same role. If the role has grants performed outside of Terraform, or other snowflake_role_grants for the same role, they will remain untouched during create, destory, or update operations.

## See also

- [immuta/terraform-snowflake-fast-data-warehouse](https://github.com/immuta/terraform-snowflake-fast-data-warehouse) was the inspiration for this project. This project is a lean version of the immuta project, which has more features eg: modules for creating roles. immuta uses a single provider configuration, whereas this project makes the required roles (ACCOUNTADMIN, SECURITYADMIN etc.) explicit.
