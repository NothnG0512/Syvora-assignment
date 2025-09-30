This repository provides a complete, production-ready solution for the given assignment.
It covers:

 Containerization of the Node Express REST API

 CI/CD to build & push Docker images

 Infrastructure as Code (Terraform) to provision an EKS cluster

 Helm deployment to Kubernetes

Follow the steps below to run everything locally, deploy to AWS, and enable monitoring.

 Run the App Locally with Docker

To quickly test the application on your machine:

# Clone the Node Express API repo next to this repo OR copy these files into it
git clone https://github.com/rwieruch/node-express-server-rest-api app
cd app

# Build and start the containers
docker compose up --build

# Open in your browser
http://localhost:4000


 Need a different port? Edit docker-compose.yml and update the exposed port.

 Continuous Integration (GitHub Actions)

A GitHub Actions workflow (.github/workflows/ci-docker.yml) automatically:

Builds a multi-architecture Docker image whenever you push to main

Pushes the image to Docker Hub

Set the following secrets in your GitHub repo:

DOCKERHUB_USERNAME

DOCKERHUB_TOKEN (Docker Hub access token)

Images are pushed with:

DOCKERHUB_USERNAME/node-express-api:latest

DOCKERHUB_USERNAME/node-express-api:<git-sha>

 Provision EKS with Terraform

Before you start:

Have an AWS account with the CLI configured

Install Terraform (v1.6 or newer)

Deploy the cluster:

cd terraform
terraform init
terraform plan -out tfplan
terraform apply tfplan


Once complete, configure kubectl:

terraform output kubeconfig
# Example:
aws eks update-kubeconfig --name syvora-devops-eks --region us-east-1

 Deploy the App with Helm

Update the Docker image in helm/node-express-api/values.yaml:

image:
  repository: yourname/node-express-api
  tag: "latest"


Then deploy:

helm upgrade --install api ./helm/node-express-api


Retrieve the external URL:

kubectl get svc -l app.kubernetes.io/name=node-express-api -w

 Bonus: Logging & Monitoring

For production-like observability, you can add:

 Metrics & Dashboards (Prometheus + Grafana)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack

 Centralized Logs (Fluent Bit to CloudWatch)
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update
helm upgrade --install fluent-bit fluent/fluent-bit \
  --set backend.type=cloudwatch \
  --set backend.cloudWatch.logGroupName=/eks/syvora/api \
  --set backend.cloudWatch.region=us-east-1


Suggested alerts in Alertmanager:

Pod restarts exceed a threshold within 5 minutes

High CPU/memory usage on nodes

High API 5xx error rates (via blackbox exporter or ingress metrics)

 Notes & Tips

The app listens on port 4000. Probes default to / which works with Express. Update if your routes differ.

Terraform uses spot instances by default to save cost. Switch to ON_DEMAND or adjust sizes as needed.

Service type is LoadBalancer. For Ingress setups, change it to ClusterIP and create an Ingress resource.

This setup provides a full DevOps workflow—from local development to cloud deployment—with CI/CD, infrastructure automation, and monitoring, all ready for real-world scenarios.
<img width="733" height="2778" alt="image" src="https://github.com/user-attachments/assets/b8f72bed-3c79-47d4-b45f-cd278d3c5460" />
