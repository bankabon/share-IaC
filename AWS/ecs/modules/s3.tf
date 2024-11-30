resource "aws_s3_bucket" "codepipeline" {
  bucket = "${var.env}-${var.name}-ecs"

  tags = {
    Name        = "terraform"
    Environment = "ture"
  }
}

resource "aws_s3_bucket_ownership_controls" "private_acl_ownership" {
  bucket = aws_s3_bucket.codepipeline.bucket
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "codepopline" {
  bucket = aws_s3_bucket.codepipeline.id
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


#alb log bucket
resource "aws_s3_bucket" "alb" {
  bucket = "${var.env}-${var.name}-alb-logs"

  tags = {
    Name        = "terraform"
    Environment = "ture"
  }
}

resource "aws_s3_bucket_ownership_controls" "private_acl_ownership2" {
  bucket = aws_s3_bucket.alb.bucket
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "alb" {
  bucket = aws_s3_bucket.alb.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::582318560864:root"
          },
          "Action" : "s3:PutObject",
          "Resource" : "${aws_s3_bucket.alb.arn}/*"
        }
        # {
        #     "Effect": "Allow",
        #     "Principal": {
        #         "AWS": "arn:aws:iam::${var.account}:user/wafcharm"
        #     },
        #     "Action": "s3:ListBucket",
        #     "Resource": [
        #         "${aws_s3_bucket.alb.arn}",
        #         "${aws_s3_bucket.alb.arn}/*"
        #     ]
        # }
      ]
    }
  )
}