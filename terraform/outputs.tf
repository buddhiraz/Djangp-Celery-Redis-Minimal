# Output ECR Repository URL
output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = data.aws_ecr_repository.app_repo.repository_url
}

# Output ECS Cluster ID
output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.ecs_cluster.id
}

# Output ECS Service Name
output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.ecs_service.name
}

# Output ECS Task Definition ARN
output "ecs_task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.task_definition.arn
}
