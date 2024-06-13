data "aws_vpc" "main" {
  filter {
    name = "tag:Name"
    values = ["main"]
  }
}

data "aws_ecs_cluster" "main" {
  cluster_name = var.ecs_cluster_name
}