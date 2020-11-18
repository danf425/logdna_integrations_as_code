provider "aws" {
#  version = "~> 3.0"
  region  = var.region
}

#Lambda Execution Role
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-lambda-execution-role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach-s3-read-access-role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


#Lambda + S3 Permissions
resource "aws_lambda_permission" "logdna_allow_bucket_permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.logdna_s3.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}
#Lambda Function Setup
resource "aws_lambda_function" "logdna_s3" {
  function_name = var.logdna_lambda_function_name
  description   = "Logdna Lambda Function for S3 integration provisioned through TF"
  s3_bucket     = var.logdna_s3_bucket
  s3_key        = var.logdna_s3_key
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = var.logdna_lambda_handler
  runtime       = var.logdna_lambda_runtime
  environment {
    variables = {
      LOGDNA_KEY = var.logdna_api_key
    }
  }
  timeout       = var.logdna_lambda_timeout
  memory_size   = var.logdna_lambda_memory_size

  # depends_on = [
  #   aws_iam_role_policy_attachment.attach-lambda-execution-role,
  #   aws_iam_role_policy_attachment.attach-s3-read-access-role
  # ]  
}

#Create/Edit S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.logdna_s3_bucket_name
}

#S3 Lambda notifications (LOGS!)
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.logdna_s3.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.logdna_allow_bucket_permission]
}