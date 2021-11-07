# Database

This module creates a database and assigns [reader and admin role grants](grants.tf) to the passed in roles. The database is owned by SYSADMIN and supports:

- a single admin role (ie: single tenancy). All schemas created will be owned by this role.
- multiple admin roles (ie: multi tenancy). Each role can create schemas that only they can see and own.

The admin role(s) should be granted to SYSADMIN outside this module so that SYSADMIN can access schemas and tables created by the admin role(s).

Schemas and tables are managed by the application (eg: dbt) using the admin role.
