resource "aws_wafv2_web_acl" "corporate" {
  name        = "corporate-${var.env}-acl"
  description = "Managed rule by wafcharm."
  scope       = "CLOUDFRONT"
 
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.metric_name
    sampled_requests_enabled   = true
  }

}