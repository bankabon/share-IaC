# static terraform (VPC)
# 現在の使用状況

| Production stage | 更新日 | 作成者 |
|  --- | --- | --- |
| test |2024/9 | K.T |

## main.tf VPC module
| name | value |
| ---  |  ---  |
| env_prefix | 環境ステージ名 |
| environment | 環境ステージ名 |
| env_name  | 環境名 |
| vpc_cidr | IPアドレス範囲（VPC） |
| public_alb_cidrs| 変数 |
| bankabon-prod-(service)-(1~) | 変数　resouce実行名|
| subnet | VPC サブネット　サブネットマスク |
| name | subnet name |
| az   |  subnet AZ|

##　仕様
- 