# Snowflake terraform kit

Modules for:

- [database](modules/database) creates a database and assigns reader and admin role grants to the passed in roles. Schemas and tables are managed by another application (eg: dbt) using the admin role.
- [warehouse](modules/warehouse) creates a warehouse and resource monitor and assigns role grants to the passed in role.
- [service-account](modules/service-account) creates a Snowflake user and AWS Secrets Manager secret to hold the password.

The [jaffle shop example](jaffles.tf) uses these modules to create production and development databases.

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

## See also

- [immuta/terraform-snowflake-fast-data-warehouse](https://github.com/immuta/terraform-snowflake-fast-data-warehouse) was the inspiration for this project. This project is a lean version of the immuta project, which has more feature eg: creating roles. immuta uses a single provider configuration, whereas this project makes the required roles (ACCOUNTADMIN, SECURITYADMIN etc.) explicit.
