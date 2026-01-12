locals {
  repos    = jsondecode(file("${path.module}/repos.json"))
  policies = jsondecode(file("${path.module}/policies.json"))
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}


resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


module "service_account_policy" {
  source      = "./modules/policy"
  for_each    = { for policy in local.policies : policy.name => policy }
  name        = each.value.name
  description = each.value.description
  policy_json = jsonencode(each.value.policy_json)
}

module "github_oidc_role" {
  source            = "./modules/github_oidc_role"
  for_each          = { for repo in local.repos : repo.repo => repo }
  repo              = each.value.repo
  name              = split("/", each.value.repo)[1]
  policy_json       = jsonencode(each.value.policy_json)
  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
}

resource "random_id" "tfstate" {
  byte_length = 4
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
