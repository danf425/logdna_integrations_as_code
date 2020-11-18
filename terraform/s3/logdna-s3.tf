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

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "test-attach-2" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


#Lambda + S3 Permissions
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}
#Lambda Function Setup
resource "aws_lambda_function" "func" {
  function_name = "danf-tf-s3-logdna"
  description   = "Logdna Lambda Function for S3 integration provisioned through TF"
  s3_bucket     = "dan-cloudwatch-logdna"
  s3_key        = "logdna-s3.zip"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs10.x"
  environment {
    variables = {
      LOGDNA_KEY = "00bac37a61229321dccc92408d807189"
    }
  }
  timeout       = 30
  memory_size   = 128
}

#Create/Edit S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "danf-tf-test-bucket"
}

#S3 Lambda notifications (LOGS!)
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.func.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}