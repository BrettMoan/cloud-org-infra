resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = var.assume_role_policy
  description        = var.description
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.policies)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies
  name     = each.key
  role     = aws_iam_role.this.id
  policy   = jsonencode(each.value)
}
