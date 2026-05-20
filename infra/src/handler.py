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
    """
    Main Lambda entry point invoked by the S3 ObjectCreated event notification.

    Parameters
    ----------
    event : dict
        S3 event payload containing one or more Records with bucket and key.
    context : LambdaContext
        Runtime information provided by the Lambda service.

    Returns
    -------
    dict
        HTTP-style response with statusCode and body.
    """
    logger.info(
        "Processing started",
        extra={
            "request_id": context.aws_request_id,
            "record_count": len(event.get("Records", [])),
        },
    )

    for record in event["Records"]:
        source_bucket = record["s3"]["bucket"]["name"]
        object_key = record["s3"]["object"]["key"]

        logger.info(
            "Reading object",
            extra={"bucket": source_bucket, "key": object_key},
        )

        # Retrieve the object from the source bucket.
        response = s3_client.get_object(Bucket=source_bucket, Key=object_key)
        file_content = response["Body"].read()

        # ── Apply business logic / transformation ─────────────────────────────
        # Replace _transform() with the actual processing logic for your use
        # case (e.g. CSV parsing, image resizing, data validation, etc.).
        processed_content = _transform(file_content, object_key)
        # ─────────────────────────────────────────────────────────────────────

        destination_key = f"processed/{object_key}"

        logger.info(
            "Writing processed object",
            extra={"bucket": DESTINATION_BUCKET, "key": destination_key},
        )

        s3_client.put_object(
            Bucket=DESTINATION_BUCKET,
            Key=destination_key,
            Body=processed_content,
        )

        logger.info(
            "Processing complete",
            extra={
                "request_id": context.aws_request_id,
                "source_key": object_key,
                "destination_key": destination_key,
            },
        )

    return {
        "statusCode": 200,
        "body": json.dumps({"message": "File processing completed successfully"}),
    }


def _transform(content: bytes, key: str) -> bytes:
    """
    Placeholder transformation — returns the file unchanged.

    Replace this function body with the actual business logic for your use
    case. The function must be idempotent: processing the same object twice
    must produce the same output (S3 event delivery has at-least-once
    semantics).

    Parameters
    ----------
    content : bytes
        Raw file bytes read from the source bucket.
    key : str
        S3 object key; can be used to branch on file type.

    Returns
    -------
    bytes
        Transformed file bytes to be written to the destination bucket.
    """
    # TODO: implement transformation logic
    return content
