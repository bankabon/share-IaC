output "waf_acl" {
    value = module.waf.waf_acl
}

# output "s3_bucket_alb" {
#     value = "s3://${module.waf.s3_bucket_alb}/prefix/AWSLogs/${data.aws_caller_identity.account.account_id}/elasticloadbalancing/ap-northeast-1/"
# }

output "s3_bucket_waf" {
  value = "s3://${module.waf.s3_bucket_waf}"
}