module "create-codepipeline" {
  source = "../module"

  env  = "bankabon"
  name = "test"

  #codepipeline
  #source
  repository_id = "<git hub use ripository>"
  branch_name   = "<branch>"

  #gitconnect既存の使いますか？ 
  use_github = false
  connectid = "<codepipeline github connection arn>"

  #build
  use_web    = true
  object_key = "test"
  

  #codedeploy設定
  autoscaling_groups = "infra-test-webapp"
  target_group_name  = "infra-test-webapp"

  build_environment = [
    {
      name  = "xx",
      value = "xx"
    },
    {
      name = "xx",
      value = "xx" }]

  #get
  vpc_id          = data.terraform_remote_state.created-vpc.outputs.vpc_id
  subnet_ids_code = data.terraform_remote_state.created-vpc.outputs.codepipeline_subnet
}