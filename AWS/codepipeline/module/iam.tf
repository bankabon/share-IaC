#codebuild
resource "aws_iam_role" "codebuild" {
  count = var.use_web == true ? 0 : 1
  name = "${var.name}-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild" {
  count = var.use_web == true ? 0 : 1
  role = aws_iam_role.codebuild[0].name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs",
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": "*"
    },
		{
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": "*"
		}
  ]
}
POLICY
}

#codedeploy
resource "aws_iam_role" "appRole" {
  name = "${var.name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.appRole.name
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployDeployerAccessRole" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployDeployerAccess"
  role       = aws_iam_role.appRole.name
}

resource "aws_iam_role_policy" "codedeploy_policy" {
  name = "${var.name}-codedeploy_policy"
  role = aws_iam_role.appRole.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "iam:PassRole",
        "ec2:CreateTags",
        "ec2:RunInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

#codepipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.env}-${var.name}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.env}-${var.name}-codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect":"Allow",
          "Action": [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning",
            "s3:PutObjectAcl",
            "s3:PutObject"
          ],
          "Resource": [
            "${aws_s3_bucket.codepipeline_bucket.arn}",
            "${aws_s3_bucket.codepipeline_bucket.arn}/*",
            "arn:aws:s3:::${local.deploy_bucket_name}",
            "arn:aws:s3:::${local.deploy_bucket_name}/*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "codestar-connections:UseConnection"
          ],
          "Resource": "${local.gitconnect}"
        },
        {
          "Effect": "Allow",
          "Action": [
            "codebuild:BatchGetBuilds",
            "codebuild:StartBuild"
          ],
          "Resource": "*"
        }
      ]
    }
  )  
}