import base64
import os

import boto3
import snowflake.connector
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

# Example of how to use an account's private key to connect to Snowflake

aws_region = os.getenv("AWS_DEFAULT_REGION")
secret_id = "snowflake.user.privatekey.DEV_JAFFLES_SA"
secretsmanager = boto3.client("secretsmanager", region_name=aws_region)
private_key_base64 = secretsmanager.get_secret_value(SecretId=secret_id)["SecretString"]

print("connecting...")

with snowflake.connector.connect(
    user="DEV_JAFFLES_SA",
    role="DEV_JAFFLES_ADMIN",
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    region=os.getenv("SNOWFLAKE_REGION"),
    private_key=base64.b64decode(private_key_base64),
) as conn:
    with conn.cursor() as cur:
        print(cur.execute("select 'hello world';").fetchone())

print("generating private key pem file")

private_key_path = '/tmp/private_key.txt'

with open(private_key_path, 'w') as f:
    key_content = f"""-----BEGIN RSA PRIVATE KEY-----\n{private_key_base64}\n-----END RSA PRIVATE KEY-----"""
    f.write(key_content)

# test we can read the private key in the same way dbt does (ie: using openssl)
# see https://github.com/dbt-labs/dbt-snowflake/blob/0f06342/dbt/adapters/snowflake/connections.py#L201
with open(private_key_path, 'rb') as key:
    p_key = serialization.load_pem_private_key(
        key.read(),
        password=None,
        backend=default_backend())

private_key_bytes = p_key.private_bytes(
            encoding=serialization.Encoding.DER,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption())

print("connecting using pem file")

with snowflake.connector.connect(
    user="DEV_JAFFLES_SA",
    role="DEV_JAFFLES_ADMIN",
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    region=os.getenv("SNOWFLAKE_REGION"),
    private_key=private_key_bytes,
) as conn:
    with conn.cursor() as cur:
        print(cur.execute("select 'hello dbt';;").fetchone())
