module "create-apprunner" {
  source = "../modules"

  env  = "bankabon"
  name = "test3"

  domain      = "<use_domain>"
  domain_name = "<sub domain>"

  #githubの設定
  github_repositoryurl = "<use git repository>"
  branch               = "<use git branch>"
  github_account_arn   = "<code pipeline github connection arn>"

  #git or ecsどっちつかいますか？
  use_github = false #適宜変更使う場合はgithubとの連携を手動でやる必要があります。
  #https://qiita.com/akahori_s/items/32316d0aff9218654b01

  #ecr使用する場合
  ecr_uri                  = "<use apprunner ECR URI>"
  code-pipeline-branch     = "<use git branch>"
  ConectionArn             = "<code pipeline github connection arn>"
  code-pipeline-repository = "<use git repository>"

  #サブネット関連
  codebuild_subnet = data.terraform_remote_state.vpc.outputs.code_build_id
  apprunner_subnet = data.terraform_remote_state.vpc.outputs.private_nat_ids
  vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
}