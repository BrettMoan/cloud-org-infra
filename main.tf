terraform {
  required_version = ">= 1.14.3"
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

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

import {
  to = aws_iam_openid_connect_provider.github
  id = "arn:aws:iam::655366068412:oidc-provider/token.actions.githubusercontent.com"
}


module "github_oidc_role" {
  source         = "./modules/github_oidc_role"
  for_each       = { for repo in local.repos : repo.repo => repo }
  repo           = each.value.repo
  name           = split("/", each.value.repo)[1]
  policy_actions = each.value.policy_actions
  oidc_provider_arn  = aws_iam_openid_connect_provider.github.arn
}

# import {
#   to = module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_policy.this
#   identity = {
#     "arn" = "arn:aws:iam::655366068412:policy/cloud-org-infra"
#   }
# }

import {
  to =  module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_policy.this
  identity = {
    "arn" = "arn:aws:iam::655366068412:policy/cloud-org-infra-tf"
  }
}

import {
  to =  module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_role.this
  identity = {
    name = "cloud-org-infra-tf"
  }
}


import {
  to = module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_role_policy_attachment.this
  identity = {
    role       = "cloud-org-infra-tf"
    policy_arn = "arn:aws:iam::655366068412:policy/cloud-org-infra-tf"
  }
}


resource "random_id" "tfstate" {
  byte_length = 4
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "brettmoan-tfstate-${random_id.tfstate.hex}"
}

resource "aws_s3_bucket" "tfstate_dev" {
  bucket = "brettmoan-dev-tfstate-${random_id.tfstate.hex}"
}

resource "aws_s3_bucket" "tfstate_qa" {
  bucket = "brettmoan-qa-tfstate-${random_id.tfstate.hex}"
}

resource "aws_s3_bucket" "tfstate_stg" {
  bucket = "brettmoan-stg-tfstate-${random_id.tfstate.hex}"
}

resource "aws_s3_bucket" "tfstate_prod" {
  bucket = "brettmoan-prod-tfstate-${random_id.tfstate.hex}"
}