terraform {
  backend "s3" {
    bucket = "brettmoan-tfstate-427302de"
    key = "cloud-org-infra/replace-me-using--backend-config/terraform.tfstate"
    region = "us-east-1" # or your region
  }
}
