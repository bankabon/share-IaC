module "wafcharm_waf" {
  source = "../modules/aws/waf"
  env    = "prod"

  name = "<productionname>"
  desc = "For corporate_cloudfront"
}
