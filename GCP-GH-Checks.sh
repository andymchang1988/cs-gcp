PROJECT_ID="sanguine-rhythm-477418-t9"
PROJECT_NUM=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

echo "Using Project Number: $PROJECT_NUM"

echo "=== Creating GitHub deployer service account ==="
gcloud iam service-accounts create github-deployer \
  --description="SA for GitHub Actions CI/CD to GKE" \
  --display-name="GitHub Deployer"

echo "=== Granting IAM roles ==="
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:github-deployer@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator"

echo "=== Creating Workload Identity Pool ==="
gcloud iam workload-identity-pools create github-pool \
  --location="global" \
  --display-name="GitHub Pool" || true

echo "=== Creating Workload Identity Provider ==="
gcloud iam workload-identity-pools providers create-oidc github-provider \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub" \
  --issuer-uri="https://token.actions.githubusercontent.com" || true

echo "=== Binding GitHub identities to impersonate the SA ==="

gcloud iam service-accounts add-iam-policy-binding \
  github-deployer@$PROJECT_ID.iam.gserviceaccount.com \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUM/locations/global/workloadIdentityPools/github-pool/*"

echo "=== DONE ==="
echo "Your WIF provider string is:"
echo "projects/$PROJECT_NUM/locations/global/workloadIdentityPools/github-pool/providers/github-provider"

echo "Your service account is:"
echo "github-deployer@$PROJECT_ID.iam.gserviceaccount.com"

