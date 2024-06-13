resource "aws_ecs_task_definition" "api_task" {
  family                   = "hello-world-api"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([{
    name  = "hello-world-api"
    image = "ntse/hello-world-api:${var.image_tag}"
    essential = true
    memory = 256
    cpu = 256
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    environment = [
      {
        name  = "MEMCACHED_HOST"
        value = data.aws_elasticache_cluster.memcached.cluster_address
      },
      {
        name  = "MEMCACHED_PORT"
        value = tostring(data.aws_elasticache_cluster.memcached.port)
      }
    ]
  }])
}

resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_task.arn
  desired_count   = 1

  launch_type = "EC2"
}