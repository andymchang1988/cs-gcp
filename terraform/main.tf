locals {
  services = [
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com"
locals {
  services = [
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_project_service" "enabled" {
  for_each = toset(local.services)
  service  = each.key
}

resource "google_artifact_registry_repository" "repo" {
  repository_id = var.repo_name
  location      = var.region
  format        = "DOCKER"
}

resource "google_container_cluster" "autopilot" {
  name     = var.cluster_name
  location = var.region
  enable_autopilot = true
}


resource "google_project_service" "enabled" {
  for_each = toset(local.services)
  service  = each.key
}

resource "google_artifact_registry_repository" "repo" {
  repository_id = var.repo_name
  location      = var.region
  format        = "DOCKER"
}

resource "google_container_cluster" "autopilot" {
  name     = var.cluster_name
  location = var.region
  enable_autopilot = true
}
