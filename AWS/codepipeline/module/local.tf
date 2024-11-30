locals {
  deploy_bucket_name = aws_s3_bucket.codepipeline_bucket.bucket
}

locals {
  gitconnect = var.use_github ? "${aws_codestarconnections_connection.github[0].arn}" : var.connectid
}