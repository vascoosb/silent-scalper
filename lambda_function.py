import boto3
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    quarantine_bucket = os.environ['QUARANTINE_BUCKET']
    
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        
        # Get the file size
        response = s3.head_object(Bucket=bucket_name, Key=object_key)
        file_size = response['ContentLength']
        
        # Check if file size exceeds 1MB
        if file_size > 1 * 1024 * 1024:  # 1MB in bytes
            # Copy the file to the quarantine bucket
            s3.copy_object(
                Bucket=quarantine_bucket,
                CopySource={'Bucket': bucket_name, 'Key': object_key},
                Key=object_key
            )
            # Delete the original file
            s3.delete_object(Bucket=bucket_name, Key=object_key)
            print(f"File {object_key} quarantined due to size {file_size} bytes.")
        else:
            print(f"File {object_key} is within size limit.")