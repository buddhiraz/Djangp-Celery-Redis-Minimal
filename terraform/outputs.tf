# Output the ECS Cluster ID
output "ecs_cluster_id" {
  description = "ID of the ECS Cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
}

# Output the ECS Service Name
output "ecs_service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.ecs_service.name
}
