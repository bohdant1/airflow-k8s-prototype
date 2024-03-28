awslocal sqs create-queue --queue-name localstack-queue
awslocal cloudformation create-stack \
    --stack-name sqs-trigger-example \
    --template-body file://sqs-trigger-example.yml \
    --capabilities CAPABILITY_NAMED_IAM
