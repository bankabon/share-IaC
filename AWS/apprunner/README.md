# Create AWS Apprunnner terraform
# 使用状況
| Service name | 作成日 | 作成者 | 最終更新 |
| --- | --- | --- | --- |
| 初期構築 | 2023/12 | K.T| - |



## main.tf
| service name | value | 
| --- | --- |
| env | 環境名|
| nmae | 環境ステージ名|
| domain | route53登録してあるアドレス |
| domain_name | route53紐付けアドレス|
| github_repositoryurl | git hub repository URL|
| branch | git hub branch|
| github_account_arn | apprunner git連携版のgitの設定 | 
| use_github | git_hubとの連携のコネクターを作るかどうか |
| ecr_uri | ECR リポジトリーURL |
| code-pipeline-branch | ECR使用時のcodepipelineのbranch |
| connnectionArn | codepipeline用のソースconnection arn |
| codepipeline-repository | codepiprline sorce側で見るリポジトリー |
## 仕様
- apprunnerは現状２通りです。
  - GITHUB連携のものと、ECRのものの２通りになります。


- ecr使用のapprunner
  - ecr使用時はcodepipelineを組みビルドまで自動化
  - 後にapprunner側で自動デプロイ、または手動デプロイ

### GITHUB側構築方法

- 現状使用されておりませんが念の為残してあります。
- GITHUBのリポジトリの指定とVPCコネクターが必要になります。
- main.tfの下記の部分を切り替えてご利用ください。
```
use_github = false
#trueでGITHUBを使う設定,falseでECRを使用する設定
```
- AWS_vpc_idをterraform cloudからgetしてくるようになっているためget.tfを編集してください。
- その他main.tfを修正してください。
- use_githubでGITHUB連携の方法かECR連携か選べます。

### ECR側構築方法

- 流れとしてはECRにイメージを入れる⇨apprunnerにデプロイするという流れです。
- buildに関しては、codepipelineでdockerイメージを作成後、pushしています。
- 初期構築
  - 手動でECRリポジトリを作成
  - ローカルでdockerイメージを作成
  - 手動でECRにローカルのイメージをpush
  - 各所main.tf,[ecr_uri],[ConectionArn]を書き換えて現状のAWSでの設定値を反映させてください。
  - 各所合わせたところでapplyしてください。
- ECRのタグはlatestで更新されていきます。

## 特記事項
