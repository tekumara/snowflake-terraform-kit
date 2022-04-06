# Snowflake terraform kit

Modules for:

- [database](modules/database) creates a database and assigns reader and admin role grants to the passed in roles. Schemas and tables are managed by another application (eg: dbt) using the admin role.
- [warehouse](modules/warehouse) creates a warehouse and resource monitor and assigns role grants to the passed in role.
- [service-account](modules/service-account) creates a Snowflake user and AWS Secrets Manager secret to hold the private key.
- [workspace](modules/workspace) creates all of the above: a database, warehouse, user, secret plus a role.

Examples:

- Jaffle shop [production](prod-jaffles.tf) using the workspace module.
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

Create the [example](main.tf) terraform plan:

```
terraform apply -var-file account.tfvars
```

## Notes

All objects are owned by SYSADMIN.

chanzuckerberg/terraform-provider-snowflake [doesn't support ALL grants](https://github.com/chanzuckerberg/terraform-provider-snowflake/discussions/318) for good reason.

A snowflake_role_grants resource will only manage its own grants. There can be multiple snowflake_role_grants for the same role. If the role has grants performed outside of Terraform, or other snowflake_role_grants for the same role, they will remain untouched during create, destory, or update operations.

### Object grants

Database object grants by default are owned by a single resource. Grants in other resources for the same object, or applied outside terraform, will be overwritten.

#### Why?

The [grantid struct](https://github.com/chanzuckerberg/terraform-provider-snowflake/blob/c07d5820bea7ac3d8a5037b0486c405fdf58420e/pkg/resources/grant_helpers.go#L79) is defined as:

```
type grantID struct {
    ResourceName string
    SchemaName   string
    ObjectName   string
    Privilege    string
    GrantOption  bool
}
```

eg: [snowflake_database_grant](https://github.com/chanzuckerberg/terraform-provider-snowflake/blob/c07d5820bea7ac3d8a5037b0486c405fdf58420e/pkg/resources/database_grant.go#L86), [snowflake_schema_grant](https://github.com/chanzuckerberg/terraform-provider-snowflake/blob/c07d5820bea7ac3d8a5037b0486c405fdf58420e/pkg/resources/table_grant.go#L137), [snowflake_table_grant](https://github.com/chanzuckerberg/terraform-provider-snowflake/blob/c07d5820bea7ac3d8a5037b0486c405fdf58420e/pkg/resources/table_grant.go#L137), and [snowflake_view_grant](https://github.com/chanzuckerberg/terraform-provider-snowflake/blob/c07d5820bea7ac3d8a5037b0486c405fdf58420e/pkg/resources/view_grant.go#L134) (to name just a handful).

This means there can only be one grant per (resource|schema|object|priv|grantoption) combination. If there is more than one resource, then they will clobber each other and you'll see changes detected on refresh. For an example see [#733](https://github.com/chanzuckerberg/terraform-provider-snowflake/issues/733).

#### Enabling multiple grants

To avoid this, assign the grant to all roles in a single resource, or use [enable_multiple_grants = true](https://github.com/chanzuckerberg/terraform-provider-snowflake/blob/5182361c48463325e7ad830702ad58a9617064df/docs/resources/table_grant.md#optional):

> enable_multiple_grants (Boolean) When this is set to true, multiple grants of the same type can be created. This will cause Terraform to not revoke grants applied to roles and objects outside Terraform.

## See also

- [immuta/terraform-snowflake-fast-data-warehouse](https://github.com/immuta/terraform-snowflake-fast-data-warehouse) was the inspiration for this project. This project is a lean version of the immuta project, which has more features eg: modules for creating roles. immuta uses a single provider configuration, whereas this project makes the required roles (ACCOUNTADMIN, SECURITYADMIN etc.) explicit.
