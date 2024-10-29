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

# Fetch Public IP of ECS Task
data "aws_ecs_task" "task" {
  cluster = aws_ecs_cluster.ecs_cluster.id
  task_arn = aws_ecs_service.ecs_service.task_arns[0]
  depends_on = [aws_ecs_service.ecs_service]
}

output "ecs_task_public_ip" {
  description = "Public IP address of the ECS task"
  value       = data.aws_ecs_task.task.network_interfaces[0].association.public_ip
}
