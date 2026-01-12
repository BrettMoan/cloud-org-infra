terraform {
  backend "s3" {
    bucket = "brettmoan-qa-tfstate-a5d103ec"
    key = "cloud-org-infra/terraform.tfstate"
    region = "us-east-1" # or your region
  }
}
