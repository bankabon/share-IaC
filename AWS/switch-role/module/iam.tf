resource "aws_iam_role" "switchrole-fullaccess" {
  for_each = toset(var.account_id)

  name = "switch-role-${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            for acc_id in var.account_id : "arn:aws:iam::${acc_id}:root"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "switchrole" {
  for_each = toset(var.account_id)

  name       = "switch-role-${each.key}"
  roles      = [aws_iam_role.switchrole-fullaccess[each.key].name]
  policy_arn = var.policy_arn != "" ? var.policy_arn : "arn:aws:iam::aws:policy/ReadOnlyAccess"
  
}