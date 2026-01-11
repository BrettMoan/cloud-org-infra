terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}


locals {
  repos = jsondecode(file("${path.module}/repos.json"))
}

module "github_oidc_role" {
  source         = "./modules/github_oidc_role"
  for_each       = { for repo in local.repos : repo.repo => repo }
  repo           = each.value.repo
  name           = split("/", each.value.repo)[1]
  policy_actions = each.value.policy_actions
}

import {
  to = module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_policy.this
  identity = {
    "arn" = "arn:aws:iam::655366068412:policy/cloud-org-infra"
  }
}