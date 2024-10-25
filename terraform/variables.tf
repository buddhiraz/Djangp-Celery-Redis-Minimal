variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster Name"
  default     = "django-celery-redis-backend-cluster"
}

variable "ecs_service_name" {
  description = "ECS Service Name"
  default     = "django-celery-redis-backend-service"
}

variable "ecs_task_family" {
  description = "ECS Task Family Name"
  default     = "django-task"
}

variable "ecr_repository_name" {
  description = "ECR Repository Name"
  default     = "django-celery-redis-backend"
}

variable "image" {
  description = "Docker image URI"
  type        = string
}

variable "container_port" {
  description = "Container Port"
  default     = 8000
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  default     = 1
}

# New variables for Celery Worker and Celery Beat

variable "celery_worker_memory" {
  description = "Memory for the Celery worker"
  default     = 512
}

variable "celery_worker_cpu" {
  description = "CPU units for the Celery worker"
  default     = 256
}

variable "celery_beat_memory" {
  description = "Memory for the Celery beat"
  default     = 256
}

variable "celery_beat_cpu" {
  description = "CPU units for the Celery beat"
  default     = 128
}
