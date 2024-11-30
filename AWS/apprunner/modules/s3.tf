#codepipeline用のS3バケット
resource "aws_s3_bucket" "codepipeline" {
  count  = var.use_github == true ? 0 : 1
  bucket = "${var.env}-${var.name}-apprunner"

  tags = {
    Name        = "terraform"
    Environment = "ture"
  }
}

#オーナー権限
resource "aws_s3_bucket_ownership_controls" "private_acl_ownership" {
  count  = var.use_github == true ? 0 : 1
  bucket = aws_s3_bucket.codepipeline[0].bucket
  rule {
    object_ownership = "ObjectWriter"
  }
}

#S3のアクセスポリシー
resource "aws_s3_bucket_policy" "codepopline" {
  count  = var.use_github == true ? 0 : 1
  bucket = aws_s3_bucket.codepipeline[0].id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "SSEAndSSLPolicy",
    "Statement" : [{
      "Sid" : "DenyUnEncryptedObjectUploads",
      "Effect" : "Deny",
      "Principal" : "*",
      "Action" : "s3:PutObject",
      "Resource" : "${local.bucket_arn}/*",
      "Condition" : {
        "StringNotEquals" : {
          "s3:x-amz-server-side-encryption" : "aws:kms"
        }
      }
      },
      {
        "Sid" : "DenyInsecureConnections",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : "${local.bucket_arn}/*",
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      }

    ]
    }
  )
}