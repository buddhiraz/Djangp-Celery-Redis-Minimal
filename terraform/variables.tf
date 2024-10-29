# AWS Region
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ECS Cluster Name
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "django-cluster"
}

# ECS Service Name
variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "django-celery-redis-backend-service"
}

# ECS Task Family
variable "ecs_task_family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = "django-task-family"
}

# Desired Count for ECS Service
variable "desired_count" {
  description = "Desired number of ECS tasks for the service"
  type        = number
  default     = 1
}

# ECR Repository Name
variable "ecr_repository_name" {
  description = "ECR repository name to pull images from"
  type        = string
}

# Container Image
variable "image" {
  description = "Docker image for the application"
  type        = string
}

# Redis Container Image
variable "redis_image" {
  description = "Docker image for Redis"
  type        = string
  default     = "redis:6.2"
}
# Container Port for Application
variable "container_port" {
  description = "Port the Django application will run on"
  type        = number
  default     = 8000
}


# Container Name for Application
variable "container_name" {
  description = "Name of the container in ECS task definition"
  type        = string
  default     = "django"
}
