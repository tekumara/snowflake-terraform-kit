import base64
import os

import boto3
import snowflake.connector

# Example of how to use an account's private key to connect to Snowflake

aws_region = os.getenv("AWS_DEFAULT_REGION")
secret_id = "snowflake.user.privatekey.DEV_JAFFLES_SA"
secretsmanager = boto3.client("secretsmanager", region_name=aws_region)
private_key_bytes = secretsmanager.get_secret_value(SecretId=secret_id)["SecretString"]

print("connecting...")

with snowflake.connector.connect(
    user="DEV_JAFFLES_SA",
    role="DEV_JAFFLES_ADMIN",
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    region=os.getenv("SNOWFLAKE_REGION"),
    private_key=base64.b64decode(private_key_bytes),
) as conn:
    with conn.cursor() as cur:
        print(cur.execute("show databases;").fetchall())
