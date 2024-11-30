#waf用バケット
resource "aws_s3_bucket" "wafcharm" {
  bucket = "aws-waf-logs-${var.name}-${var.env}-wafcharm"

  tags = {
    Name        = "terraform"
    Environment = "ture"
  }
}



resource "aws_s3_bucket_ownership_controls" "private_acl_ownership" {
  bucket = aws_s3_bucket.wafcharm.bucket
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "wafcharm" {
  bucket = aws_s3_bucket.wafcharm.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "AWSLogDeliveryWrite20150319",
    "Statement": [
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.wafcharm.arn}/AWSLogs/${var.account}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control",
                    "aws:SourceAccount": "${var.account}"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:ap-northeast-1:${var.account}:*"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.wafcharm.arn}",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "${var.account}"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:logs:ap-northeast-1:${var.account}:*"
                }
            }
        }
    ]
    }
  )
}


#alblog用バケット
# resource "aws_s3_bucket" "alblog_bucket" {
#   bucket = "aws-waf-${var.name}-alb-logs"

#   tags = {
#     Name        = "terraform"
#     Environment = "ture"
#   }
# }

# resource "aws_s3_object" "log_directry" {
#   bucket = aws_s3_bucket.alblog_bucket.id
#   key = "prefix/" #ディレクトリだけ作るのでソースはなし
# }

# resource "aws_s3_bucket_ownership_controls" "private_acl_ownership2" {
#   bucket = aws_s3_bucket.alblog_bucket.bucket
#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }

# resource "aws_s3_bucket_policy" "alb" {
#   bucket = aws_s3_bucket.alblog_bucket.id
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::582318560864:root"
#             },
#             "Action": "s3:PutObject",
#             "Resource": "${aws_s3_bucket.alblog_bucket.arn}/*"
#         },
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "${aws_iam_user.wafcharm-user.arn}"
#             },
#             "Action": "s3:ListBucket",
#             "Resource": [
#                 "${aws_s3_bucket.alblog_bucket.arn}",
#                 "${aws_s3_bucket.alblog_bucket.arn}/*"
#             ]
#         }
#     ]
#   }
#   )
# }

#ここのALBのバケットは各ECSなどのALBに標準でloggingをonにして対応予定。