awslocal cloudformation create-stack \
    --stack-name s3-trigger-example \
    --template-body file://s3-trigger-example.yml \
    --capabilities CAPABILITY_NAMED_IAM
