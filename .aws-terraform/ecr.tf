resource "aws_ecr_repository" "my_ecr_repo_resource" {
  name                 = "my_ecr_repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
