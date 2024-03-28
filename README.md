# Scheduling and Orchestration with Apache Airflow on AWS

## Description

Orchestrating ETL pipelines can be hard. This repository contains:
1. Ready-to-deploy local airflow environment based in KIND (k8s in docker) cluster.
2. Examples of event-driven ETL orchestration (S3 upload -> Lambda trigger -> Airflow ETL pipeline trigger).
3. All needed AWS resources templated via CloudFormation.

## Prerequisites

1. See `airflow-k8s-cluster/README.MD`

## Getting started

1. `source airflow-k8s-cluster/up.sh`
2. `source restart.sh`
3. `cd <needed-folder>`
4. `source up.sh`

## S3 trigger specific

1. ```bash
   awslocal s3api put-object --bucket eventbucket \
   --key dummyfile.txt --body=dummyfile.txt
   ```

## Stream logs

1. `awslocal logs tail '/aws/lambda/\<lambda-name\>' --follow`

