localstack stop
localstack start -d
awslocal s3 mb s3://my-lambda-function-code
awslocal s3 mb s3://lambda-function-code-s3-trigger
awslocal s3 mb s3://lambda-function-code-s3-trigger-airflow
awslocal s3 mb s3://testbucket 

