#!/bin/bash

# Set error flag
error_occurred=false

# Function to generate a random tag
generate_random_tag() {
    echo "v$(date +%s)"
}

# Check if kind is installed
if ! command -v kind &>/dev/null; then
    echo "Error: kind is not installed. Please install kind before running this script."
    error_occurred=true
fi

# Check if kubectl is installed
if ! command -v kubectl &>/dev/null; then
    echo "Error: kubectl is not installed. Please install kubectl before running this script."
    error_occurred=true
fi

# Exit if errors occurred
if [ "$error_occurred" = true ]; then
    exit 1
fi

# Step 1: Create Kind cluster
echo "Step 1: Creating Kind cluster..."
if kind create cluster --name airflow-cluster --config kind-cluster.yaml; then
    echo "Kind cluster created successfully."
else
    echo "Error: Failed to create Kind cluster."
    error_occurred=true
fi

# Step 2: Create namespace
echo "Step 2: Creating namespace 'airflow'..."
if kubectl create namespace airflow; then
    echo "Namespace 'airflow' created successfully."
else
    echo "Error: Failed to create namespace 'airflow'."
    error_occurred=true
fi

# Step 3: Build Docker image for Airflow
echo "Step 3: Building Docker image for Airflow..."
random_tag=$(generate_random_tag)
if docker build -t cutsomairflow:$random_tag . ; then
    echo "Docker image built successfully."
else
    echo "Error: Failed to build Docker image for Airflow."
    error_occurred=true
fi

# Step 4: Load Docker image into Kind cluster
echo "Step 4: Loading Docker image into Kind cluster..."
if kind load docker-image cutsomairflow:$random_tag --name airflow-cluster; then
    echo "Docker image loaded into Kind cluster successfully."
else
    echo "Error: Failed to load Docker image into Kind cluster."
    error_occurred=true
fi

# Step 5: Add Apache Airflow Helm repository
echo "Step 5: Adding Apache Airflow Helm repository..."
if helm repo add apache-airflow https://airflow.apache.org; then
    echo "Apache Airflow Helm repository added successfully."
else
    echo "Error: Failed to add Apache Airflow Helm repository."
    error_occurred=true
fi

# Step 6: Update Helm repositories
echo "Step 6: Updating Helm repositories..."
if helm repo update; then
    echo "Helm repositories updated successfully."
else
    echo "Error: Failed to update Helm repositories."
    error_occurred=true
fi

# Step 7: Search for Airflow Helm chart in repositories
echo "Step 7: Searching for Airflow Helm chart in repositories..."
if helm search repo airflow; then
    echo "Airflow Helm chart found."
else
    echo "Error: Airflow Helm chart not found."
    error_occurred=true
fi

# Step 8: Install Airflow Helm chart
echo "Step 8: Installing Airflow Helm chart..."
if helm upgrade --install airflow apache-airflow/airflow --namespace=airflow -f override-values.yaml \
  --set dags.persistence.enabled=false \
  --set dags.gitSync.enabled=true \
  --set images.airflow.repository=cutsomairflow \
  --set images.airflow.tag=$random_tag; then
    echo "Airflow Helm chart installed successfully."
else
    echo "Error: Failed to install Airflow Helm chart."
    error_occurred=true
fi

# Step 9: Start localstack
echo "Step 9: Starting localstack..."
if localstack start -d; then
    echo "Localstack started successfully."
else
    echo "Error: Failed to start localstack."
    error_occurred=true
fi

# Step 10: Deploy AWS CloudFormation stack
echo "Step 10: Deploying AWS CloudFormation stack..."
if awslocal cloudformation deploy \
    --stack-name test-stack \
    --template-file "./s3.yaml"; then
    echo "AWS CloudFormation stack deployed successfully."
else
    echo "Error: Failed to deploy AWS CloudFormation stack."
    error_occurred=true
fi

# Step 11: Port forward for Airflow webserver
echo "Step 11: Port forwarding for Airflow webserver..."
kubectl port-forward svc/airflow-webserver 8080:8080 --namespace airflow &
port_forward_pid=$!

# Trap function to catch exit signal and kill the port-forward process
trap 'kill $port_forward_pid' EXIT

# Wait indefinitely, keeping the script running
wait

# Exit with appropriate status code
if [ "$error_occurred" = true ]; then
    exit 1
else
    exit 0
fi
