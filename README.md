# logdna_cloudformation_integrations

## LogDNA CloudWatch and S3 Integrations
- Go to CloudFormation
- Make sure you are in your desired region (Internally I have my bucket in us-east-1 so it will only work there)
- Create New Stack, upload new resources, choose either the `cloudwatch` or `s3` yaml, click `Next`
- Change Owner, Email, and API. The rest is optional
- Create Stack

### NOTES (Read if using outside of LogDNA AWS Org):
- You will first need to upload the integration zipped file to a specific bucket. This will only work if lambda/CF is in the same region as your bucket. 
- If you are within the LogDNA AWS account and in the us-east-1 region, then this will work as is. I'm hosting the zipped file on a pre-created S3 bucket located in us-east-1 (s3://dan-cloudwatch-logdna/logdna-xxxxx.zip)
- If you are working outside of the LogDNA AWS account, then you need to change the `S3Bucket` and `S3Key` fields to point to your zipped file. These are located within `LogDNCWALambdaFunction` for CloudWatch and `LogDNAS3LambdaFunction` for S3:
```
  LogDNACWLambdaFunction:
    Type: AWS::Lambda::Function
    Properties: 
      Code:     
        S3Bucket: dan-cloudwatch-logdna
        S3Key: logdna-cloudwatch.zip
```  
  

### Potential fix for s3 bucket situation 
- In order for this to work outside of us-east-1, I'm thinking about either of these two fixes: 
    - Option 1: LogDNA should host our integration zipped files in an public S3 bucket by default (use https://github.com/secureoptions/cfs3-uploader)
    - Option 2: As part of CF template, I can create an ec2 instance (t3.micro) to download the zipped file from GH, and upload it to an s3 bucket... probably through user-data.
