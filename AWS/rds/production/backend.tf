terraform {
  backend "s3" {
    bucket               = "<terraform S3 bucket>"
    key                  = "<created aws keyid>"
    region               = "ap-northeast-1"
    workspace_key_prefix = ""
  }
}
