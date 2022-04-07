# Service account

This module creates a Snowflake user and AWS Secrets Manager secret to hold their private key. A resource policy grants cross-account access to the secret.

NB: The private key will also be stored in Terraform state. You will need to treat this as secret.

See [connect.py](connect.py) for how to use the private key with the snowflake connector for Python. 
