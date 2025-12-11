gke-cicd-demo/
├── app/
│   ├── Dockerfile
│   └── entrypoint.sh
├── k8s/
│   ├── staging.yaml
│   └── prod.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
└── .github/
    └── workflows/
        └── deploy.yaml
