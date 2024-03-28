# lcp-k8s-airflow-playground

## Getting started

### Prerequisites 

1. `brew install kubernetes-cli`
2. `brew install kind`
3. `brew install helm`
4. `brew install localstack`
5. `brew install awscli-local`
6. Running docker daemon 

### SetUp an SSH to your Git Repo

This setup uses GitSync, a service that pulls Airflow DAGs via SSH.
To set up your own SSH, see [here](./setup-ssh.md).

### How to start

1. `source up.sh`

### How to stop

1. `source down.sh`

### **Important**

- It can take 5-7 minutes to start the environment from scratch
