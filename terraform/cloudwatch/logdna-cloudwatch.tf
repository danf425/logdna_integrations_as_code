provider "aws" {
#  version = "~> 3.0"
  region  = var.region
}


#Lambda Function Setup
resource "aws_lambda_function" "logdna_cloudwatch" {
  function_name = var.logdna_lambda_function_name
  description   = "Logdna Lambda Function for CloudWatch integration provisioned through TF"
  s3_bucket     = var.logdna_s3_bucket
  s3_key        = var.logdna_s3_key
  role          = aws_iam_role.iam_for_logdna_cloudwatch_lambda.arn
  handler       = var.logdna_lambda_handler
  runtime       = var.logdna_lambda_runtime
  environment {
    variables = {
      LOGDNA_KEY = var.logdna_api_key
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.attach-lambda-execution-role,
    aws_iam_role_policy_attachment.attach-cloudwatch-execution-role,
    aws_cloudwatch_log_group.logdna_log_group
  ]
}

#Create Log Groups
resource "aws_cloudwatch_log_group" "logdna_log_group" {
  name = var.logdna_log_group_name
  retention_in_days = var.logdna_log_group_retention
#   tags = {
#     Environment = "production"
#     Application = "serviceA"
#   }
}

#Create Logstream associate w/ Log Group for testing purposes
resource "aws_cloudwatch_log_stream" "logdna_log_stream" {
  name           = var.logdna_test_stream
  log_group_name = aws_cloudwatch_log_group.logdna_log_group.name
}

#Lambda Permissions here:
resource "aws_lambda_permission" "allow_cloudwatch" {
  #statement_id  = "Allow-execution-from-cloudwatch"
  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.logdna_cloudwatch.arn
  function_name = aws_lambda_function.logdna_cloudwatch.arn
  principal     = "logs.us-east-1.amazonaws.com"
#  source_arn    = aws_cloudwatch_log_group.logdna_log_group.arn
  source_arn = length(regexall(":\\*$", aws_cloudwatch_log_group.logdna_log_group.arn)) == 1 ? aws_cloudwatch_log_group.logdna_log_group.arn : "${aws_cloudwatch_log_group.logdna_log_group.arn}:*"

}

#Create CloudWatch Subscription Filter (aka Lambda Function Trigger event)
resource "aws_cloudwatch_log_subscription_filter" "logdna_subscription_filter" {
  name            = "logdna-log-subscription-filter"
  depends_on      = ["aws_lambda_permission.allow_cloudwatch"]
  destination_arn = aws_lambda_function.logdna_cloudwatch.arn
  filter_pattern  = ""
  log_group_name  = aws_cloudwatch_log_group.logdna_log_group.name
#  role_arn        = aws_iam_role.iam_for_lambda.arn
#  distribution    = "Random"
}

#Lambda Execution Role
resource "aws_iam_role" "iam_for_logdna_cloudwatch_lambda" {
  name = "iam_for_logdna_cloudwatch_lambda"

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
  role       = aws_iam_role.iam_for_logdna_cloudwatch_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "attach-cloudwatch-execution-role" {
  role       = aws_iam_role.iam_for_logdna_cloudwatch_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
