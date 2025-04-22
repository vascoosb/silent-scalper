# Silent Scalper (Serverless Data Processing)

A serverless pipeline to process uploaded files, track metadata, and quarantine failures.

## Features

- **S3** triggers **Lambda** to process uploads and store metadata in **DynamoDB**
- Faulty files moved to a quarantine S3 bucket
- **SNS** alerts for critical errors
- Monitoring and logs via **CloudWatch**

## Tech Stack

- AWS Lambda
- API Gateway
- AWS S3
- DynamoDB
- SNS
- CloudWatch

## In Progress

- Adding IAM roles with least privilege
- Finalising retry/error logic
- Working on deployment via Terraform

## Outcome

Efficient, serverless ingestion system with automated error handling and alerting.
