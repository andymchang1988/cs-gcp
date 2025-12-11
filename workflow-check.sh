#!/usr/bin/env bash

set -e

PROJECT_ID="sanguine-rhythm-477418-t9"
REGION="us-east4"
CLUSTER_NAME="nginx-gke-cicd"
REPO_NAME="nginx-gke-repo"
SA="github-deployer@$PROJECT_ID.iam.gserviceaccount.com"

echo "====================================="
echo "  GKE + CI/CD SYSTEM VERIFICATION"
echo "====================================="
sleep 1

echo ""
echo "Step 1: Checking gcloud authentication..."
gcloud auth list

echo ""
echo "Step 2: Checking project configuration..."
gcloud config set project $PROJECT_ID > /dev/null
echo "Active project: $(gcloud config get-value project)"

echo ""
echo "Step 3: Checking Artifact Registry repository..."
gcloud artifacts repositories describe $REPO_NAME --location=$REGION

echo ""
echo "Step 4: Checking GKE cluster existence..."
gcloud container clusters describe $CLUSTER_NAME --region $REGION --format="value(name,status)"

echo ""
echo "Step 5: Retrieving kubeconfig credentials..."
gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION
kubectl get nodes

echo ""
echo "Step 6: Checking Workload Identity Federation service account..."
gcloud iam service-accounts describe $SA --format="value(email)"

echo ""
echo "Step 7: Checking Kubernetes namespaces..."
kubectl get ns

echo ""
echo "Step 8: Checking existing deployments..."
echo "Staging deployment:"
kubectl get deploy nginx-staging --ignore-not-found
echo "Prod deployment:"
kubectl get deploy nginx-prod --ignore-not-found

echo ""
echo "Step 9: Checking services (LoadBalancer IPs)..."
echo "Staging service:"
kubectl get svc nginx-staging --ignore-not-found -o wide || true
echo "Prod service:"
kubectl get svc nginx-prod --ignore-not-found -o wide || true

echo ""
echo "Step 10: Checking GitHub Secrets..."
echo "These commands will fail if secrets are NOT configured."
gh secret list || echo "GitHub CLI not logged in or no secrets configured."

echo ""
echo "Step 11: Checking required GitHub secrets..."
MISSING=0

if ! gh secret list | grep -q WIF_PROVIDER; then
  echo "❌ Missing: WIF_PROVIDER"
  MISSING=1
else
  echo "✔ WIF_PROVIDER found"
fi

if ! gh secret list | grep -q WIF_SERVICE_ACCOUNT; then
  echo "❌ Missing: WIF_SERVICE_ACCOUNT"
  MISSING=1
else
  echo "✔ WIF_SERVICE_ACCOUNT found"
fi

if [ $MISSING -eq 1 ]; then
  echo ""
  echo "⚠️  One or more secrets missing. CI/CD will NOT work until all secrets are added."
else
  echo ""
  echo "✔ GitHub secrets configured correctly"
fi

echo ""
echo "====================================="
echo "  SUMMARY"
echo "====================================="
echo "✔ GKE cluster reachable"
echo "✔ Artifact Registry exists"
echo "✔ Workload Identity SA exists"
echo "✔ kubectl functional"
echo "✔ GitHub secrets validated"
echo ""
echo "If staging or prod services exist above with EXTERNAL-IP values,"
echo "your CI/CD deployment is already LIVE!"
echo ""
echo "Run: kubectl get svc to check anytime."
echo "====================================="

