output "waf_acl" {
  value = aws_wafv2_web_acl.wafcharm_alb.id
}

output "s3_bucket_waf" {
  value = aws_s3_bucket.wafcharm.id
}

# output "s3_bucket_alb" {
#   value = aws_s3_bucket.alblog_bucket.id
# }