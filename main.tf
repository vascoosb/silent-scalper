provider "aws" {
    region = "eu-west-2" # london init bruv
}

resource "aws_s3_bucket" "uploads" {
  bucket = "my-upload-bucket-name"
}

resource "aws_s3_bucket" "quarantine" {
  bucket = "my-quarantine-bucket-name"
}


resource "aws_iam_role" "lambda_exec" {
    name = "lambda_exec_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy" "s3_access" {
    name = "s3_access_policy"
    role = aws_iam_role.lambda_exec.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject",
                    "s3:CopyObject",
                    "s3:ListBucket"
                ]
                Effect = "Allow"
                Resource = [
                    aws_s3_bucket.uploads.arn,
                    "${aws_s3_bucket.uploads.arn}/*",
                    aws_s3_bucket.quarantine.arn,
                    "${aws_s3_bucket.quarantine.arn}/*"
                ]
            }
        ]
    })
}

resource "aws_lambda_function" "my_lambda" {
    filename = "function.zip"
    function_name = "lambda_handler"
    role = aws_iam_role.lambda_exec.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.9"
    source_code_hash = filebase64sha256("function.zip")
    environment {
    variables = {
      QUARANTINE_BUCKET = aws_s3_bucket.quarantine.bucket
    }
  }
}

resource "aws_s3_bucket_notification" "trigger_lambda" {
    bucket = aws_s3_bucket.uploads.id
        lambda_function {
        lambda_function_arn = aws_lambda_function.my_lambda.arn
        events              = ["s3:ObjectCreated:*"]
        }
    depends_on = [aws_lambda_permission.allow_s3]

}

resource "aws_lambda_permission" "allow_s3" {
    statement_id  = "AllowS3Invoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.my_lambda.function_name
    principal     = "s3.amazonaws.com"
    source_arn    = aws_s3_bucket.uploads.arn
}