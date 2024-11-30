module "vpc" {
  source = "../modules/vpc"

  env_prefix  = "test"
  environment = "test"
  env_name    = "production-test"
  vpc_cidr    = "10.50.0.0/20"


// public subnet用
    public_subnet_cidrs = {
      production-test-nat-1a = {
      subnet = "10.50.12.0/24"
      name   = "production-test-nat-1a"
      az     = "ap-northeast-1a"
    }
}


// public subnet alb用
    public_subnet_alb_cidrs = {
      production-test-alb-1a = {
      subnet = "10.50.0.0/24"
      name   = "production-test-alb-1a"
      az     = "ap-northeast-1a"
    }
      production-test-alb-1c = {
      subnet = "10.50.1.0/24"
      name   = "production-test-alb-1c"
      az     = "ap-northeast-1c"
    }
      production-test-alb-1d = {
      subnet = "10.50.2.0/24"
      name   = "production-test-alb-1d"
      az     = "ap-northeast-1d"
    }
}

// public subnet nat用
  public_subnet_nat_cidrs = {
    production-test-codepipeline-1a = {
      subnet = "10.50.13.0/24"
      name   = "production-test-codepipeline-1a"
      az     = "ap-northeast-1a"
    }
    production-test-ec2-1a = {
      subnet = "10.50.3.0/24"
      name   = "production-test-ec2-1a"
      az     = "ap-northeast-1a"
    }
    production-test-ec2-1c = {
      subnet = "10.50.4.0/24"
      name   = "production-test-ec2-1c"
      az     = "ap-northeast-1c"
    }
    production-test-ec2-1d = {
      subnet = "10.50.5.0/24"
      name   = "production-test-ec2-1d"
      az     = "ap-northeast-1d"
    }
  }

// private subnet用
  private_subnet_cidrs = {
    production-test-rds-1a = {
      subnet = "10.50.6.0/24"
      name   = "production-test-rds-1a"
      az     = "ap-northeast-1a"
    }
    production-test-rds-1c = {
      subnet = "10.50.7.0/24"
      name   = "production-test-rds-1c"
      az     = "ap-northeast-1c"
    }
    production-test-rds-1d = {
      subnet = "10.50.8.0/24"
      name   = "production-test-rds-1d"
      az     = "ap-northeast-1d"
    }
  }
}

// ../modules/nat-instaceの設定に継承する
module "ec2" {
  //module.vpcが完全に作成された後に実行される
  depends_on = [module.vpc]
  //"../modules/nat-instance": 使用するモジュールのパスを指定
  source     = "../modules/nat-instance"

  env  = "production"
  name = "test"

  // EC2インスタンスのタイプ
  instance_type     = "t2.nano"
  // インスタンスに関連付けるSSHキーペアの名前
  key_name          = "ec2-key"
  // EC2インスタンスに付与するIAMロール
  iam_instance      = "ssm-role"
  //インスタンスプラベートアドレス
  ip_address = "10.50.12.254"

  // 作成するEC2インスタンスが属するVPCのIDを指定
  vpc_id     = module.vpc.vpc_id
  // NATインスタンスを配置するパブリックサブネットのIDを指定 1番目のサブネットを指定
  nat_subnet = module.vpc.public_subnet_ids[0]
  // NATインスタンスが関連付けられるルートテーブルのIDを指定
  route_table_id = module.vpc.route_table_id

}