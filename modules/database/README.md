# Database

This module creates a database and assigns [reader and admin role grants](grants.tf) to the passed in roles. The database is owned by SYSADMIN and only a single admin role is allowed to create, and therefore own, schemas. This creates a single tenancy database.

The admin role should be granted to SYSADMIN outside this module.

Schemas and tables are managed by another application (eg: dbt) using the admin role.
