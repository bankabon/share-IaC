# resource "aws_ecr_repository" "this" {
#   count                = var.use_github == true ? 0 : 1
#   name                 = "apprunner-${var.name}-${var.env}"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

#terraform上でecr作る場合はコメントアウト外してください。
#main.tfの改変も必要です。apprunner.tfも合わせて編集してください。