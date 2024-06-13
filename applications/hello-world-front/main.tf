resource "aws_lb" "frontend_alb" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.subnets.ids

  enable_deletion_protection = false

  tags = {
    Name = "frontend-alb"
  }
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "hello-world-frontend"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode([{
    name  = "hello-world-frontend"
    image = "ntse/hello-world-frontend:${var.image_tag}"
    essential = true
    memory = 256
    cpu = 256
    portMappings = [{
      containerPort = 5000
      hostPort      = 5000
    }]
    environment = [
      {
        # We'd use something better than this really, using the external address is simpler for
        # demo purposes.
        name  = "API_URL"
        value = "http://${data.aws_instance.ecs_instance.public_ip}:8080"
      }
    ]
  }])
}

resource "aws_ecs_service" "frontend_service" {
  name            = "frontend-service"
  cluster         = data.aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 1

  launch_type = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_tg.arn
    container_name   = "hello-world-frontend"
    container_port   = 5000
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = data.aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}