output "next_steps" {
  value = <<EOT
After apply, run:

  gcloud container clusters get-credentials ${var.cluster_name} --region ${var.region}

Then deploy staging:

  kubectl apply -f k8s/staging.yaml

And deploy prod:

  kubectl apply -f k8s/prod.yaml

EOT
}
