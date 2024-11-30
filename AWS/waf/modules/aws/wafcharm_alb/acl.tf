resource "aws_wafv2_web_acl" "wafcharm_alb" {
  name        = "${var.env}-${var.name}-acl"
  description = "Managed rule by wafcharm."
  scope       = "REGIONAL"
 
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = local.metric_name
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "wafcharm_alb" {
  log_destination_configs = [aws_s3_bucket.wafcharm.arn]
  resource_arn = aws_wafv2_web_acl.wafcharm_alb.arn
}

resource "aws_wafv2_web_acl_association" "wafcharm" {
  web_acl_arn = aws_wafv2_web_acl.wafcharm_alb.arn
  resource_arn = var.alb_arn
}