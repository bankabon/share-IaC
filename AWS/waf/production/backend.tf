terraform {
  backend "s3" {
    bucket = "<s3 bucket>"
    key    = "<key>"
    region = "ap-northeast-1"
  }
}
