#apprunner用iam
resource "aws_iam_role" "role" {
  name               = "apprunner-${var.name}-${var.env}"
  assume_role_policy = file("../modules/json/role.json")
}

resource "aws_iam_policy" "apprunnner" {
  name   = "apprunner-${var.name}-${var.env}"
  path   = "/"
  policy = file("../modules/json/policy.json")
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.apprunnner.arn
}

#ecr
resource "aws_iam_role" "ecs-role" {
  count              = var.use_github == true ? 0 : 1
  name               = "ecr-apprunner-${var.name}-${var.env}"
  assume_role_policy = file("../modules/json/ecr_role.json")
}

resource "aws_iam_policy" "ecs-apprunnner" {
  count  = var.use_github == true ? 0 : 1
  name   = "ecs-apprunner-${var.name}-${var.env}"
  path   = "/"
  policy = file("../modules/json/ecr_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecr-apprunner-attach" {
  count      = var.use_github == true ? 0 : 1
  role       = aws_iam_role.ecs-role[0].name
  policy_arn = aws_iam_policy.ecs-apprunnner[0].arn
}

#codepipeline
resource "aws_iam_role" "codepipeline" {
  count              = var.use_github == true ? 0 : 1
  name               = "codepipeline-apprunner-${var.name}-${var.env}"
  assume_role_policy = file("../modules/json/codepipeline_role.json")
}

resource "aws_iam_policy" "codepipeline" {
  count  = var.use_github == true ? 0 : 1
  name   = "codepipeline-apprunner-${var.name}-${var.env}"
  path   = "/"
  policy = file("../modules/json/codepipeline_policy.json")
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  count      = var.use_github == true ? 0 : 1
  role       = aws_iam_role.codepipeline[0].name
  policy_arn = aws_iam_policy.codepipeline[0].arn
}

#codebuild
resource "aws_iam_role" "codebuild" {
  count              = var.use_github == true ? 0 : 1
  name               = "codebuild-apprunner-${var.name}-${var.env}"
  assume_role_policy = file("../modules/json/codebuild_role.json")
}

resource "aws_iam_policy" "codebuild_log" {
  count = var.use_github == true ? 0 : 1
  name  = "codebuild-apprunner-${var.name}-${var.env}"
  path  = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Resource" : [
            "${aws_cloudwatch_log_group.apprunner[0].arn}",
            "${aws_cloudwatch_log_group.apprunner[0].arn}:*"
          ],
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        },
        {
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::codepipeline-ap-northeast-1-*"
          ],
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "codebuild:CreateReportGroup",
            "codebuild:CreateReport",
            "codebuild:UpdateReport",
            "codebuild:BatchPutTestCases",
            "codebuild:BatchPutCodeCoverages"
          ],
          "Resource" : [
            "${aws_codebuild_project.apprunner[0].arn}*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_policy" "codebuild_ec2" {
  count = var.use_github == true ? 0 : 1
  name  = "codebuild-ec2-${var.env}-${var.name}"
  path  = "/"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeVpcs"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateNetworkInterfacePermission"
          ],
          "Resource" : "arn:aws:ec2:ap-northeast-1:${data.aws_caller_identity.self.account_id}:network-interface/*",
          "Condition" : {
            "StringEquals" : {
              "ec2:Subnet" : [
                "arn:aws:ec2:ap-northeast-1:${data.aws_caller_identity.self.account_id}:subnet/${var.codebuild_subnet}"
              ],
              "ec2:AuthorizedService" : "codebuild.amazonaws.com"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "codebuild_ec2" {
  count      = var.use_github == true ? 0 : 1
  role       = aws_iam_role.codebuild[0].name
  policy_arn = aws_iam_policy.codebuild_ec2[0].arn
}

resource "aws_iam_role_policy_attachment" "codebuild_log" {
  count      = var.use_github == true ? 0 : 1
  role       = aws_iam_role.codebuild[0].name
  policy_arn = aws_iam_policy.codebuild_log[0].arn
}

resource "aws_iam_role_policy_attachment" "codepipeline_ecr" {
  count      = var.use_github == true ? 0 : 1
  role       = aws_iam_role.codebuild[0].name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
}

resource "aws_iam_role_policy_attachment" "s3" {
  count      = var.use_github == true ? 0 : 1
  role       = aws_iam_role.codebuild[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


