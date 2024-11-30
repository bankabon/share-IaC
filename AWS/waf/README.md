# Create AWS WAF terraform
## 使用状況
| Service name | 作成日 | 作成者 | 最終更新 |
| --- | --- | --- | --- |
| cloud front WAF | - | T.S | - |
| ALB WAF | 2024/7 | K.T | - |

## Cloud front WAF main.tf
| service name | value | 
| --- | --- |
| env | 環境ステージ |
| name | 環境名前 |
| desc |　説明 |


## ALB WAF main.tf
| service name | value | 
| --- | --- |
| env | 環境 |
| name | 環境名 |
| desc | 説明 |
| metric_name | 環境名 |
| alb_arn | ALBのarn |
| account | アカウントID自動取得 |


## 仕様
- S3のバケット、ポリシーは手動でwafcharmと連携が取れるようにしてください。

## 特記事項
- IAMは手動で作ってください。