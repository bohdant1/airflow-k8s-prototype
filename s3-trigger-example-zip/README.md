## To zip

1. cd src
1. zip -r -D MyBundledLambdaFunctionCode.zip *
1. mv MyBundledLambdaFunctionCode.zip ..


## To watch logs 

1. awslocal logs tail '/aws/lambda/S3TriggerExampleFunction' --follow



