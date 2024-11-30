locals {
  bucket_arn = aws_s3_bucket.codepipeline[0].arn#直書きだとうまくいかなかったのでlocal定義
}

locals {
  log = aws_cloudwatch_log_group.apprunner[0].name#直書きだとうまくいかなかったのでlocal定義
}