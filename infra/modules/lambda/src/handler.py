"""
File Processor Lambda Handler

Reads an uploaded file from the source S3 bucket, applies a transformation,
and writes the result to the destination S3 bucket.

Environment variables
---------------------
SOURCE_BUCKET      : Name of the S3 source bucket (injected by Terraform)
DESTINATION_BUCKET : Name of the S3 destination bucket (injected by Terraform)
"""

import json
import logging
import os

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SOURCE_BUCKET = os.environ["SOURCE_BUCKET"]
DESTINATION_BUCKET = os.environ["DESTINATION_BUCKET"]

# Reuse the boto3 client across warm invocations.
s3_client = boto3.client("s3")


def handler(event, context):
    """Process S3 ObjectCreated events.

    For each record in the event, downloads the object from the source bucket,
    applies a transformation, and uploads the result to the destination bucket
    under the same key.

    Parameters
    ----------
    event : dict
        S3 event notification payload.
    context : LambdaContext
        Runtime information provided by the Lambda service.
    """
    records = event.get("Records", [])
    logger.info("Processing %d record(s)", len(records))

    for record in records:
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]

        logger.info("Downloading s3://%s/%s", bucket, key)
        response = s3_client.get_object(Bucket=bucket, Key=key)
        body = response["Body"].read()

        transformed = _transform(body)

        logger.info("Uploading result to s3://%s/%s", DESTINATION_BUCKET, key)
        s3_client.put_object(
            Bucket=DESTINATION_BUCKET,
            Key=key,
            Body=transformed,
        )

    return {"statusCode": 200, "processedRecords": len(records)}


def _transform(data: bytes) -> bytes:
    """Apply a transformation to the raw file bytes.

    The current implementation converts the payload to uppercase text.
    Replace this function with domain-specific processing logic.

    Parameters
    ----------
    data : bytes
        Raw file content downloaded from the source bucket.

    Returns
    -------
    bytes
        Transformed file content to be written to the destination bucket.
    """
    return data.upper()
