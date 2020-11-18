variable "logdna_lambda_function_name" {
  default = "logdna-s3-function"
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

variable "logdna_lambda_timeout" {
  type = number
  default = 30
}

variable "logdna_lambda_memory_size" {
  type = number
  default = 128
}

variable "logdna_s3_bucket_name" {
  default = "logdna-test-bucket"
}