# Autonomous AWS EKS Infrastructure with Cast AI

This project provisions a resilient Amazon EKS cluster heavily optimized for autonomous cost reduction. Instead of relying on static managed node groups and the traditional Kubernetes Cluster Autoscaler, this architecture deploys a minimal control plane and grants compute orchestration rights to Cast AI. The AI engine continuously analyzes pod resource requests driven by native Horizontal Pod Autoscalers and dynamically provisions the most cost effective AWS spot or on-demand instances in real time.

## 1. Provision Core Infrastructure and AI Integration

Set your Cast AI API token in your environment to avoid hardcoding credentials:
`export TF_VAR_castai_api_token="your-castai-api-token-here"`

Navigate to the Terraform directory and initialize the providers:
```bash
cd terraform
terraform init

Review the infrastructure plan, verifying that static node groups are minimized and AI cross-account IAM roles are defined:
terraform plan

Provision the VPC, EKS Control Plane, and AI permissions:
terraform apply -auto-approve

2. Authenticate the Cluster
Update your local kubeconfig to interact with the new control plane:
aws eks --region ap-south-1 update-kubeconfig --name sre-autonomous-cluster
cd ..

3. Deploy Workloads and Observe AI Scaling
At this stage, the Cast AI controller is running on the cluster. Deploy your application manifests to trigger a scaling event:
kubectl apply -f kubernetes/

Watch the AI detect the pending pods and automatically provision right-sized spot nodes in real time:
kubectl get nodes -l provisioner.cast.ai/managed=true -w

4. Cleanup
Destroy the infrastructure when testing is complete to halt all AWS billing:

cd terraform
terraform destroy -auto-approve
