# Database

This module creates a database and assigns [reader and admin role grants](grants.tf) to the passed in roles. Schemas and tables are managed by another application (eg: dbt) using the admin role.
