# cloud-org-infra

This repository manages cloud organization infrastructure, including DNS, subdomain, routing, and broader cloud resource configuration using Terraform and AWS. It demonstrates modular, automated setup for cloud-native applications, organizational controls, and CI/CD powered by GitHub Actions and OIDC authentication.

## Features
- DNS zone and record management (Route53)
- Subdomain, routing, and cloud resource configuration
- Organizational controls and modular infrastructure-as-code design
- OIDC-enabled GitHub Actions workflow

## Part of a Multi-Repo Demo
This repo is part of a larger, opinionated infrastructure demonstration. See the [brettmoan main overview](https://github.com/brettmoan/README.md) for the full architecture and design rationale.

---

## First time setup


1. Create an aws account: create a new free tier account at https://portal.aws.amazon.com/billing/signup?type=register
1. login to the root user, where we will setup the initial boot strap obejects to enable this project to connect to aws over github
1. create IAM policy: Yes! In the AWS Console, you can create a custom policy by pasting JSON directly:
    1. Go to IAM > Policies:  https://console.aws.amazon.com/iam/home#/policies
    1. Click "Create policy".
    1. Select the "JSON" tab.
    1. Paste your policy JSON and click "Next".
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "iam:AttachRolePolicy",
                    "iam:CreateOpenIDConnectProvider",
                    "iam:CreatePolicy",
                    "iam:CreatePolicyVersion",
                    "iam:CreateRole",
                    "iam:DeleteOpenIDConnectProvider",
                    "iam:DeletePolicy",
                    "iam:DeletePolicyVersion",
                    "iam:DeleteRole",
                    "iam:DeleteRolePolicy",
                    "iam:DetachRolePolicy",
                    "iam:GetOpenIDConnectProvider",
                    "iam:GetPolicy",
                    "iam:GetPolicyVersion",
                    "iam:GetRole",
                    "iam:ListAttachedRolePolicies",
                    "iam:ListInstanceProfilesForRole",
                    "iam:ListPolicyVersions",
                    "iam:ListRolePolicies",
                    "iam:ListRoles",
                    "iam:PutRolePolicy",
                    "iam:TagRole",
                    "iam:UntagRole",
                    "iam:UpdateAssumeRolePolicy",
                    "s3:CreateBucket",
                    "s3:DeleteBucket",
                    "s3:DeleteObject",
                    "s3:GetAccelerateConfiguration",
                    "s3:GetBucketAcl",
                    "s3:GetBucketCORS",
                    "s3:GetBucketLocation",
                    "s3:GetBucketLogging",
                    "s3:GetBucketObjectLockConfiguration",
                    "s3:GetBucketPolicy",
                    "s3:GetBucketRequestPayment",
                    "s3:GetBucketTagging",
                    "s3:GetBucketVersioning",
                    "s3:GetBucketWebsite",
                    "s3:GetEncryptionConfiguration",
                    "s3:GetLifecycleConfiguration",
                    "s3:GetObject",
                    "s3:GetReplicationConfiguration",
                    "s3:ListAllMyBuckets",
                    "s3:ListBucket",
                    "s3:PutObject"
                ],
                "Resource": "*"
            }
        ]
    }
    ```
    1. Click next
    1. name the policy `bootstrap` and description of `bootstrap`
    1. click create. You should land back on the "policies" page and see a banner that says "policy bootstrap created."

1. create a user https://console.aws.amazon.com/iam/home#/users --> 
    1. click create user. 
    1. name the user `bootstrap` to denote that it is being used to bootstap the initial steps via commandline.
    1. click `next` to go to step 2 `set permissions`
    1. keep `add user to group` selected. then select `create group`
    1. name the group `cloud-org-infra`
    1. under permissions polcies, search for and select `cloud-org-infra` created previously (you may need to hit the refresh button to make it appear).
    1. click `Create user group`
    1. check the box next to the newly created uiser group `cloud-org-infra` 
    1. click `Next` to go to step 3 `Review and create`
    1. review the settings, and click `create user`
1. get AWS Access key 
    1. go to the newly created `bootstrap` user from https://console.aws.amazon.com/iam/home#/users 
    1. click on `bootstrap` user 
    1. Go to the `Security credentials` tab.
    1. Scroll to `Access keys` and click `Create access key`.
    1. Choose `Command Line Interface (CLI)` as the use case, then click `Next`. 
    1. click the `Confirmation I understand the above recommendation and want to proceed to create an access key.`
        - because this is a bootstap, it will violate best practice for long term access. don't worry after the bootstrap, we will create a differnt user, with differnt key, and then delte this one.
    1. click `Next`
    1. click `Create access key`
    1. click `Download .csv key` save it to the root of the repo, and then click `Done`
1. install aws cli: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
1. run `aws configure`
1. paste the values from the csv file into the respective values
1. run `terraform init`
1. run `terraform plan`
1. run `terraform apply -auto-approve`