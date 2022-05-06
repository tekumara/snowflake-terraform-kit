import base64
import os
import tempfile

import boto3
import snowflake.connector
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization

# Example of how to use a private key to connect to Snowflake


def fetch_secret() -> str:
    aws_region = os.getenv("AWS_DEFAULT_REGION")
    secret_id = "snowflake.user.privatekey.DEV_JAFFLES_SA"
    secretsmanager = boto3.client("secretsmanager", region_name=aws_region)
    return secretsmanager.get_secret_value(SecretId=secret_id)["SecretString"]


def test_connect(private_key_pem: str) -> None:
    print("connecting...")

    # convert to DER bytes format for Snowflake by stripping off the PEM BEGIN/END markers and decoding
    private_key_bytes = base64.b64decode(private_key_pem[private_key_pem.find("\n") + 1 : private_key_pem.rfind("\n")])

    with snowflake.connector.connect(
        user="DEV_JAFFLES_SA",
        role="DEV_JAFFLES_ADMIN",
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        region=os.getenv("SNOWFLAKE_REGION"),
        private_key=private_key_bytes,
    ) as conn:
        with conn.cursor() as cur:
            print(cur.execute("select 'hello private key bytes';").fetchone())


def write_pem_file(private_key_path: str, private_key_pem: str) -> None:
    print(f"generating private key pem file {private_key_path}")

    with open(private_key_path, "w") as f:
        f.write(private_key_pem)


def test_connect_using_pem_file(private_key_path: str) -> None:
    # test we can read and use a private key pem file in the same way dbt does (ie: using cryptography/openssl)
    # see https://github.com/dbt-labs/dbt-snowflake/blob/0f06342/dbt/adapters/snowflake/connections.py#L201
    # and https://docs.snowflake.com/en/user-guide/python-connector-example.html#using-key-pair-authentication-key-pair-rotation
    with open(private_key_path, "rb") as key:
        p_key = serialization.load_pem_private_key(key.read(), password=None, backend=default_backend())

    # write out bytes in PKCS8 format with DER encoding
    private_key_bytes = p_key.private_bytes(
        encoding=serialization.Encoding.DER,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption(),
    )

    print("connecting using pem file")

    with snowflake.connector.connect(
        user="DEV_JAFFLES_SA",
        role="DEV_JAFFLES_ADMIN",
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        region=os.getenv("SNOWFLAKE_REGION"),
        private_key=private_key_bytes,
    ) as conn:
        with conn.cursor() as cur:
            print(cur.execute("select 'hello pem file';").fetchone())


private_key_pem = fetch_secret()
test_connect(private_key_pem)

with tempfile.NamedTemporaryFile() as tmp:
    write_pem_file(tmp.name, private_key_pem)
    test_connect_using_pem_file(tmp.name)
