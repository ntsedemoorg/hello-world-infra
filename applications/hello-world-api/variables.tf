variable "image_tag" {
    description = "The tag of the image to deploy"
    type = string
    default = "latest"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type = string
  default = "hello-world-cluster"
}