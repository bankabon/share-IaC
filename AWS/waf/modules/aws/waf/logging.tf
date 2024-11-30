resource "aws_wafv2_web_acl_logging_configuration" "corporate-wafchaem" {
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.web_acl_log.arn]
  resource_arn            = aws_wafv2_web_acl.corporate.arn
}

resource "aws_kinesis_firehose_delivery_stream" "web_acl_log" {
  name        = "aws-waf-logs-corporate-${var.env}"
  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = "arn:aws:s3:::corporate-test-prod-wafcharm" #適宜変更
  }
}

resource "aws_iam_role" "firehose" {
  name               = "aws-waf-logs-corporate-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume.json
}

data "aws_iam_policy_document" "firehose_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "firehose.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "firehose" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose_custom.arn
}

resource "aws_iam_policy" "firehose_custom" {
  name   = "corporate-${var.env}-policy"
  policy = data.aws_iam_policy_document.firehose_custom.json
}

data "aws_iam_policy_document" "firehose_custom" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload", 
      "s3:GetBucketLocation", 
      "s3:GetObject", 
      "s3:ListBucket", 
      "s3:ListBucketMultipartUploads", 
      "s3:PutObject",
    ]

    resources = [
      "*",
    ]
  }
}