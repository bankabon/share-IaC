resource "aws_iam_user" "wafcharm-user" {
  force_destroy = "false"
  name          = "wafcharm"
  path          = "/"
}

resource "aws_iam_user_policy_attachment" "waf_full" {
  policy_arn = "arn:aws:iam::aws:policy/AWSWAFFullAccess"
  user       = aws_iam_user.wafcharm-user.name
}

resource "aws_iam_user_policy_attachment" "AmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  user       = aws_iam_user.wafcharm-user.name
}

resource "aws_iam_user_policy_attachment" "CloudWatchReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  user       = aws_iam_user.wafcharm-user.name
}
