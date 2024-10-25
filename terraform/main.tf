terraform {
  backend "s3" {
    bucket         = var.terraform_backend_bucket
    key            = var.terraform_backend_key
    region         = var.region
    dynamodb_table = var.terraform_backend_dynamodb_table
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = templatefile("${path.module}/container_definitions.json.tpl", {
    container_name  = "django"
    image           = var.image
    region          = var.region
    ecs_service_name = var.ecs_service_name
    container_port  = var.container_port
  })
  requires_compatibilities  = ["FARGATE"]
  memory                    = "1024"
  cpu                       = "512"

  depends_on = [aws_cloudwatch_log_group.ecs_log_group]
}

# ECS Service
resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [for subnet in aws_subnet.public_subnets : subnet.id]
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }
}

# Output ECS Service Details
output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.ecs_service.name
}
