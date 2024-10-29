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

# Output the Public IP addresses of ECS Tasks (only if public IP is assigned)
output "ecs_task_public_ips" {
  description = "Public IP addresses assigned to ECS tasks"
  value       = [
    for eni in aws_network_interface.ecs_service_enis : eni.association.public_ip
  ]
  depends_on = [aws_ecs_service.ecs_service]
}
