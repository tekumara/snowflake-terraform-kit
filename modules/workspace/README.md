# Workspace

Creates an admin role, database, warehouse, and service account user and secret (service account).

## Admin Role

An admin role. Granted admin access to the database, and usage of the warehouse.
The service account user, SYSADMIN is granted this role, plus optionally other users.

## Reader Role (optional)

An reader role. Granted read access to the database. Can be granted to other roles.

## Database

Creates a database and assigns [reader and admin role grants](database.tf) to the passed in roles. The database is owned by SYSADMIN and supports a single admin role (ie: single tenancy). All schemas created will be owned by this role.

Schemas and tables are managed by the application (eg: dbt) using the admin role.

## Warehouse

Creates a warehouse and resource monitor and assigns role grants to the admin role.

## User and secret (service account)

Creates a Snowflake user and AWS Secrets Manager secret to hold their password. A resource policy grants cross-account access to the secret.

[sfpassman](https://github.com/tekumara/sfpassman) is used to set the password and secret. This avoids storing the password in the Terraform state file. sfpassman must be on the path and the following environment variables must be set:

- SNOWFLAKE_USER: a snowflake admin user with SECURITYADMIN permissions
- SNOWFLAKE_PASSWORD: the snowflake admin user's password
- SNOWFLAKE_REGION: the snowflake region, eg: `ap-southeast-2`
