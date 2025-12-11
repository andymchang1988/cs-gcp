variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east4"
}

variable "repo_name" {
  type    = string
  default = "nginx-gke-repo"
}

variable "cluster_name" {
  type    = string
  default = "nginx-gke-cicd"
}
