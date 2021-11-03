# Service account

This module creates a Snowflake user and AWS Secrets Manager secret to hold their password. A resource policy grants cross-account access to the secret.

[sfpassman](https://github.com/tekumara/sfpassman) is used to set the password and secret. This avoids storing the password in the Terraform state file.sfpassman must be on the path and the following environment variables must be set:

- SNOWFLAKE_USER: a snowflake admin user with SECURITYADMIN permissions
- SNOWFLAKE_PASSWORD: the snowflake admin user's password
- SNOWFLAKE_REGION: the snowflake region, eg: `ap-southeast-2`
