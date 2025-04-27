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

- Adding SNS alerts for quarantined objects
- Adding Cloudwatch dashboards
- Adding metadata storing with DybamoDB
- Adding IAM roles with least privilege
- Finalising retry/error logic

## Outcome

Efficient, serverless ingestion system with automated error handling and alerting.
