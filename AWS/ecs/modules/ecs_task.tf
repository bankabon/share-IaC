resource "aws_ecs_task_definition" "nginx-php" {
  container_definitions = jsonencode(
    [
      {
        "name" : "log_router",
        "image" : "${local.account}.dkr.ecr.ap-northeast-1.amazonaws.com/logging-firelens-fluentbit:latest",
        "cpu" : 0,
        "portMappings" : [],
        "essential" : true,
        "environment" : [],
        "mountPoints" : [],
        "volumesFrom" : [],
        "user" : "0",
        "logConfiguration" : {
          "logDriver" : "awslogs",
          "options" : {
            "awslogs-group" : "${aws_cloudwatch_log_group.ecs.name}",
            "awslogs-region" : "ap-northeast-1",
            "awslogs-stream-prefix" : "log_router_log"
          }
        },
        "firelensConfiguration" : {
          "type" : "fluentbit",
          "options" : {
            "enable-ecs-log-metadata" : "true",
            "config-file-type" : "file",
            "config-file-value" : "/fluent-bit/etc/extra.conf"
          }
        }
      },
      {
        "name" : "front",
        "image" : "${local.account}.dkr.ecr.ap-northeast-1.amazonaws.com/front:latest",
        "cpu" : 0,
        "portMappings" : [],
        "essential" : true,
        "environment" : [],
        "mountPoints" : [],
        "volumesFrom" : [],
        "logConfiguration" : {
          "logDriver" : "awsfirelens",
          "options" : {
            "Name" : "newrelic"
          },
          "secretOptions" : [
            {
              "name" : "apiKey",
              "valueFrom" : "${aws_secretsmanager_secret.newrelic.arn}"
            }
          ]
        }
      },
      {
        "name" : "web",
        "image" : "${local.account}.dkr.ecr.ap-northeast-1.amazonaws.com/web:latest",
        "cpu" : 0,
        "portMappings" : [
          {
            "containerPort" : "${var.port}",
            "hostPort" : "${var.port}",
            "protocol" : "tcp"
          }
        ],
        "essential" : true,
        "environment" : [],
        "mountPoints" : [],
        "volumesFrom" : [],
        "logConfiguration" : {
          "logDriver" : "awsfirelens",
          "options" : {
            "Name" : "newrelic"
          },
          "secretOptions" : [
            {
              "name" : "apiKey",
              "valueFrom" : "${aws_secretsmanager_secret.newrelic.arn}"
            }
          ]
        }
      },
      {
        "name" : "app",
        "image" : "${local.account}.dkr.ecr.ap-northeast-1.amazonaws.com/app:latest",
        "cpu" : 0,
        "portMappings" : [],
        "essential" : true,
        "environment" : [],
        "mountPoints" : [],
        "volumesFrom" : [],
        "logConfiguration" : {
          "logDriver" : "awsfirelens",
          "options" : {
            "Name" : "newrelic"
          },
          "secretOptions" : [
            {
              "name" : "apiKey",
              "valueFrom" : "${aws_secretsmanager_secret.newrelic.arn}"
            }
          ]
        }
      },
      {
        "name": "mysql",
        "image": "mysql:8.0",
        "cpu": 0,
        "portMappings": [],
        "essential": true,
        "environment": [
          {
            "name": "TZ",
            "value": "Asia/Tokyo"
          },
          {
            "name": "MYSQL_ROOT_HOST",
            "value": "%"
          },
          {
            "name": "MYSQL_ROOT_USER",
            "value": "root"
          },
          {
            "name": "MYSQL_ROOT_PASSWORD",
            "value": "root"
          }
        ],
        "mountPoints": [],
        "volumesFrom": [],
        "secrets": [],
        "logConfiguration": {
          "logDriver": "awsfirelens",
          "options": {
            "Name": "newrelic"
          },
          "secretOptions": [
            {
              "name": "apiKey",
              "valueFrom": "${aws_secretsmanager_secret.newrelic.arn}"
            }
          ]
        }
      },
      {
        "name" : "newrelic-infra",
        "image" : "newrelic/nri-ecs:1.10.2",
        "cpu" : 256,
        "memoryReservation" : 512,
        "portMappings" : [],
        "essential" : true,
        "environment" : [
          {
            "name" : "NRIA_CUSTOM_ATTRIBUTES",
            "value" : "{\"nrDeployMethod\":\"downloadPage\"}"
          },
          {
            "name" : "NRIA_IS_FORWARD_ONLY",
            "value" : "true"
          },
          {
            "name" : "NRIA_PASSTHROUGH_ENVIRONMENT",
            "value" : "ECS_CONTAINER_METADATA_URI,ECS_CONTAINER_METADATA_URI_V4,FARGATE"
          },
          {
            "name" : "FARGATE",
            "value" : "true"
          },
          {
            "name" : "NRIA_OVERRIDE_HOST_ROOT",
            "value" : ""
          }
        ],
        "mountPoints" : [],
        "volumesFrom" : [],
        "secrets" : [
          {
            "name" : "NRIA_LICENSE_KEY",
            "valueFrom" : "${aws_ssm_parameter.paramete-state.name}"
          }
        ]
      }
    ]
  )
  cpu                      = var.cpu
  execution_role_arn       = aws_iam_role.execution.arn
  family                   = "ecs-${var.env}-${var.name}"
  memory                   = var.memory
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  task_role_arn = aws_iam_role.taskrole.arn
}