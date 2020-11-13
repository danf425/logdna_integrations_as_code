# logdna_cloudformation_integrations

##LogDNA CloudWatch Integratoin
- Go to CloudFormation
- Make sure you are in the us-east-1 region
- Create New Stack, upload new resources, choose `cloudwatch/logdna_cloudwatch.yaml`, click `Next`
- Change Owner, Email, and API. The rest is optional
- Create Stack

Notes:
- Will only work on us-east-1. Currently pulling from an S3 bucket which is region locked. This needs to be modified.
- Need to Create IAM Role instead of using one that's specific to my current org

LogDNA S3
- Need to start