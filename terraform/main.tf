terraform {
  backend "s3" {
    bucket         = "django-bucket-1234"
    key            = "terraform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

# Data Source for Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Data Source for Existing ECR Repository
data "aws_ecr_repository" "app_repo" {
  name = var.ecr_repository_name
}

# Data Source for Existing IAM Role
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public_route_table"
  }
}

# Route to Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "public_rta" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# Security Group for ECS Service
resource "aws_security_group" "ecs_service_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs_service_sg"
  }
}

# Create CloudWatch Log Group for ECS tasks
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.ecs_service_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.ecs_service_name}-log-group"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = templatefile("${path.module}/container_definitions.json.tpl", {
    container_name  = "django"
    image           = var.image
    redis_image     = "redis:6.2"
    container_port  = var.container_port
    region          = var.region
    ecs_service_name = var.ecs_service_name  
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
