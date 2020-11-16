# logdna_cloudformation_integrations

##LogDNA CloudWatch and S3 Integrations
- Go to CloudFormation
- Make sure you are in the us-east-1 region
- Create New Stack, upload new resources, choose either the `cloudwatch` or `s3` yaml, click `Next`
- Change Owner, Email, and API. The rest is optional
- Create Stack

Notes:
- This will only work on us-east-1. I'm currently uploading the zipped folder from a pre-created S3 bucket located in us-east-1 (s3://dan-cloudwatch-logdna/logdna-xxxxx.zip)
  
- In order for this to work outside of us-east-1, I'm thinking about either of these two fixes: 
    - LogDNA should host our integration zip files in an S3 bucket by default (cross region replication) 
    - As part of CF template, I can create an ec2 instance (t3.micro) to download the zipped file from GH, and upload it to an s3 bucket... probably through user-data.
