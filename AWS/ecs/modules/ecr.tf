# resource "aws_ecr_repository" "log" {
#   name                 = "${var.env}-${var.name}-loging"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = false
#   }
# }

# resource "aws_ecr_repository" "app" {
#   name                 = "${var.env}-${var.name}-app"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = false
#   }
# }

# resource "aws_ecr_repository" "web" {
#   name                 = "${var.env}-${var.name}-web"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = false
#   }
# }