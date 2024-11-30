module "waf" {
    source = "../modules/aws/wafcharm_alb"

    env = "test"
    name = "bankabon"
    desc = "For alb"
    metric_name = "bankabon"
    alb_arn = "<ALB arn>"

    account = data.aws_caller_identity.account.account_id
    
  
}