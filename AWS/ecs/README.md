# Create AWS ECS terraform
# 使用状況
| Service name | 作成日 | 作成者 | 最終更新 |
| --- | --- | --- | --- |
| 初期構築 | 2024/11 | K.T | - |


## main.tf
| service name | value | 
| --- | --- |
| env | 環境名 |
| name | 環境ステージ名 |
| kye | secret managerのnewrelic key |
| cpu | cpu|
| memory | memory|
| port | use port|
| domain | route53の指定アドレス |
| zone_id | route53登録のドメインID |
| code-pipeline-brnach | github branch |
| code-pipeline-repository | github repository |
| useconect | git hub connnectorを新規で作るかどうか |
| buildspec | use buildspec.yml |
| ConnectionArn | git hub connector を流用で作る場合 |
| ~~~ | ~~~ |
| subnet | terraform cloudで引っ張ってくる場合はdata.terraformで引っ張れる|
## 仕様
- ECSは基本的に最低限動く範囲での設定
- CI/CD周りも全自動作成
- あくまでもtemplateなので、最低限の設定
- 下記スクリプトがbuildspec.ymlには必要

```
#!/bin/bash

# クラスター内のサービス一覧を取得
services=$(aws ecs list-services --cluster "$CLUSTER_NAME" --query 'serviceArns[*]' --output text)
if [ $? -ne 0 ]; then
    echo "Error: Failed to list services."
    exit 1
fi

echo "Services: $services"

# 各サービスに対してタスク定義を取得し、taskRoleArn、executionRoleArn、およびファミリーを取得
for service in $services; do
    echo "Processing service: $service"
    
    task_definition=$(aws ecs describe-services --cluster "$CLUSTER_NAME" --services "$service" --query 'services[0].taskDefinition' --output text)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to describe service $service."
        continue
    fi
    
    task_info=$(aws ecs describe-task-definition --task-definition "$task_definition" --query 'taskDefinition.{family:family, taskRoleArn:taskRoleArn, executionRoleArn:executionRoleArn}' --output json)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to describe task definition $task_definition."
        continue
    fi
    
    echo "Task Info: $task_info"

    family=$(echo "$task_info" | jq -r '.family')
    task_role_arn=$(echo "$task_info" | jq -r '.taskRoleArn')
    execution_role_arn=$(echo "$task_info" | jq -r '.executionRoleArn')
    
    log_group=$(aws ecs describe-task-definition --task-definition "$task_definition" --query 'taskDefinition.containerDefinitions[].logConfiguration.options."awslogs-group"' --output text)

    echo "log_group: $log_group"
done

# Secrets ManagerからシークレットのARNを取得
secret_arn=$(aws secretsmanager describe-secret --secret-id "$SECRET_NAME" --query 'ARN' --output text)
if [ $? -ne 0 ]; then
    echo "Error: Failed to describe secret $SECRET_NAME."
    exit 1
fi

echo "Secret ARN: $secret_arn"
echo "Family: $family"
echo "Task Role ARN: $task_role_arn"
echo "Execution Role ARN: $execution_role_arn"
echo "Secret ARN: $secret_arn"

sed \
    -e "s|\${FAMILY}|$family|g" \
    -e "s|\${LOG_GROUP1}|$log_group|g" \
    -e "s|\${API_KEY}|$secret_arn|g" \
    -e "s|\${TASK_ROLE}|$task_role_arn|g" \
    -e "s|\${EXECUTION_ROLE}|$execution_role_arn|g" \
    -e "s|\${CPU}|$CPU|g" \
    -e "s|\${MEMORY}|$MEMORY|g"\
    taskdef.json > task.json
```
