provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "360health-backend"
}

resource "aws_ecs_service" "ecs_service" {
  name            = "360health-backend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.django_task_def.arn
  desired_count   = 1
  launch_type     = "EC2"
}



resource "aws_ecs_task_definition" "django_task_def" {
  family                   = "django-task"
  container_definitions    = file("../infra/ecs-task-definition.json")  # Use correct relative path
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  memory                   = "512"
  cpu                      = "256"
}
