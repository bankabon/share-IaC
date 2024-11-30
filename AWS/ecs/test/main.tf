module "create_ecs" {
  source = "../modules"
  #AWS側の設定値
  #ecs側の設定
  env    = "production"
  name   = "test"
  cpu    = 1024
  memory = 2048
  port   = 80

  #paramate
  paramate_name  = "/newrelic/license-key"
  paramate_type  = "String"
  paramate_value = var.newrelic-key

  #alb関係443証明書
  domain  = "container.bankabon-test.bankabon.jp"     #設定するドメイン名
  zone_id = "Z01580792ZQE8VYN8CBXV" #route53ホストゾーンID

  #codepopelineの設定
  code-pipeline-branch     = "ecs"                         #githubのブランチ
  code-pipeline-repository = "bankabon/hentai-reader" #githubのリポジトリ
  useconect                = "no"
  buildspec                = "buildspec.yml"                                                                                            #githubのコネクションを新規で作成する場合はyes
  ConnectionArn            = "<connectionarn>" #codepipeline上souseのコネクションID

  #subnetに関しては、各所環境に合わせて調整してください。
  subnet_ids_ecs  = [data.terraform_remote_state.created-vpc.outputs.public_nat_ids[1], data.terraform_remote_state.created-vpc.outputs.public_nat_ids[2], data.terraform_remote_state.created-vpc.outputs.public_nat_ids[3]]
  subnet_ids_alb  = data.terraform_remote_state.created-vpc.outputs.public_alb_ids
  subnet_ids_code = data.terraform_remote_state.created-vpc.outputs.public_nat_ids[0]
  vpc_id          = data.terraform_remote_state.created-vpc.outputs.vpc_id
  account         = data.aws_caller_identity.account.id

}

