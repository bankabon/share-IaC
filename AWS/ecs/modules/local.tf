data "aws_caller_identity" "accout" {} #アカウントID取得用

locals {
  bucket_name = aws_s3_bucket.codepipeline.bucket
}

locals {
  bucket_arn = aws_s3_bucket.codepipeline.arn
}

locals {
  account = data.aws_caller_identity.accout.account_id
}

# locals {
#   loging = "058108814827.dkr.ecr.ap-northeast-1.amazonaws.com/logging-firelens-fluentbit"
# }

# locals {
#   app = aws_ecr_repository.app.repository_url
# }

# locals {
#   web = aws_ecr_repository.web.repository_url
# }