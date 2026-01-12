# import {
#   to = aws_iam_openid_connect_provider.github
#   id = "arn:aws:iam::655366068412:oidc-provider/token.actions.githubusercontent.com"
# }

# import {
#   to = module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_policy.this
#   identity = {
#     "arn" = "arn:aws:iam::655366068412:policy/cloud-org-infra"
#   }
# }

# import {
#   to =  module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_policy.this
#   identity = {
#     "arn" = "arn:aws:iam::655366068412:policy/cloud-org-infra"
#   }
# }

# import {
#   to =  module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_role.this
#   identity = {
#     name = "cloud-org-infra"
#   }
# }


# import {
#   to = module.github_oidc_role["BrettMoan/cloud-org-infra"].aws_iam_role_policy_attachment.this
#   identity = {
#     role       = "cloud-org-infra"
#     policy_arn = "arn:aws:iam::655366068412:policy/cloud-org-infra"
#   }
# }
