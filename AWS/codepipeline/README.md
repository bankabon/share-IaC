# codepipelineの構築
## 概要
- codepipelineを作成
- webとfrontがある

## web側構築方法
```
#main.tf
 #build
  use_web    = true
  object_key = "test"
```
- use_webをtrueに

```
  repository_id = "repository"
  branch_name   = "main"
```

- gitのリポジトリを入力、使用するブランチを設定

```
  #codedeploy設定
  autoscaling_groups = "infra-test-webapp"
  target_group_name  = "infra-test-webapp"
```

- autoscaling_groupの名前を入れてください。
- target_group_nameの名前をいれてください。
- その他VPCやcodebuildを配置するサブネットを入力またはgetで持ってきてください。

## front
- webの設定値を参考にsource,deployを設定してください。
- buildの部分はobject_keyを設定してください。
- buld_environmentは環境変数です。各所設定に合わせて設定してください。
