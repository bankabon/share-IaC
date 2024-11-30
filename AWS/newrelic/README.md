# Create Newrelic URL監視 terraform
# 使用状況
| Service name | 作成日 | 作成者 | 最終更新 |
| --- | --- | --- | --- |
| 新規構築 | 2024/1 | K.T | - |
| README.md追加 | 2024/9 | K.T | - |

## main.tf
| service name | value | 
| --- | --- |
| name | 環境名と環境ステージ（例：bankabon-test） |
| url | 監視したいURL |
| tag | var.tags[番号]で環境で指定|

## 仕様
- terraform cloudでも動作検証済み（動作確認済み）
- terraform cloud側にnewrelic-apiのvariableを定義してapplyする

## 特記事項
- newrelicなどの別サービス（google cloud , AWS）の場合はverision.tfを,modules側とproduction側両方とも定義してあげる必要がある。
- 設定は単純です。