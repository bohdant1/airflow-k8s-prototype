# Step 1: Deleting Kind cluster
echo "Step 1: Deleting Kind cluster..."
if kind delete cluster --name airflow-cluster; then
    echo "Kind cluster deleted successfully."
else
    echo "Error: Failed to delete Kind cluster."
fi

# Step 2: Stopping localstack 
echo "Step 2: Stopping localstack..."
if localstack stop; then
    echo "Stopped localstack successfully."
else
    echo "Error: Failed to stop localstack."
fi