variable "logdna_lambda_function_name" {
  default = "logdna-cloudwatch-function"
}

variable "region" {
  default = "us-east-1"
}

variable "logdna_s3_bucket" {
  default = "dan-cloudwatch-logdna"
}

variable "logdna_s3_key" {
  default = "logdna-cloudwatch.zip"
}

variable "logdna_lambda_handler" {
  default = "index.handler"
}

variable "logdna_lambda_runtime" {
  default = "nodejs10.x"
}

variable "logdna_api_key" {
  default = ""
}

variable "logdna_log_group_name" {
  default = "lodgna-group-name"
}

variable "logdna_log_group_retention" {
  type = number
  default = 14
}

variable "logdna_test_stream" {
  default = "test"
}