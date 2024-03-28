awslocal s3 cp MyBundledLambdaFunctionCode.zip s3://lambda-function-code-s3-trigger-airflow
awslocal cloudformation create-stack \
    --stack-name s3-trigger-example \
    --template-body file://s3-trigger-example.yml \
    --capabilities CAPABILITY_NAMED_IAM
