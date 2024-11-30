# IaC code sumple
## 現状
すべて動作確認済み

## 使用方法
### 環境
- S3仕様のもの
- terraform cloudのものが混在


## terraform 環境構築方法
- terraformをmacにインストールする

```
brew install hashicorp/tap/terraform
brew upgrade hashicorp/tap/terraform
```

```
terraform --version
```

```
brew unlink terraform
brew install tfenv
```

- required_version を合わせる

```
tfenv list-remote
```

- 使用したいmain.tfがあるディレクトリのversion.tfのrequired_versionをインストールする

```
tfenv list
```

- versionをインストールする

```
tfenv install (version)
```

- 使用する

```
tfenv use (version)
```
## terraformを構築するとき
### AWS terraform versions.tf
- versions.tfのterraform cloudを使用する際のコード
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
  cloud {
    organization = "<terraform cloud organization>"
    hostname     = "app.terraform.io"

    workspaces {
      name = "< terraform cloud work space name >"
    }
  }
  required_version = "~> < tfenv version >"
}
```

### 使用するにあたって
- terraform cloudを使用するにあたってcloudのオプションが必須になります。
    - このオプション内
        - organization : terraform cloud organization name
        - hostname : app.terraform.io
        - worksppaces : terraform cloud workspace name
- tfenv use versionについて
    - required_version
        - tfenv install : versionと合わせること
- required_providersについて
    - source : hashicorp/aws
        - terraformでawsのリソースをつくるよー
    - version
        - terraform を実行するときのversion
            - ここの指定を変えると新しいresourceを使えるようになったりする

## terraformを仮実行したい場合
- 使用たいmain.tfがある位置まで移動する
```
cd terraform/(aws service name)/(production)

terraform init

terraform plan
```
- プラン結果をPRに貼り付けてレビューをしてもらうこと

## terraform　フォルダー構成
```
production
| 
|-- aws service name    
|       |
|       |---- modules
|       |      |----- (aws service).tf
|       |      |-----    ~~~~~~~
|       |      |----- variable.tf
|       |      
|       |----- production
|       |         |-- main.tf
|       |         |-- version.tf
|       |         |-- get.tf (任意)
|       |         |-- provider.tf
|       |         |-- variable.tf(任意)
|       |         |-- README.md
```
## 公式ドキュメントURL
- terraform resource ナレッジ
    - terraform : https://registry.terraform.io/providers/hashicorp/aws/latest/docs