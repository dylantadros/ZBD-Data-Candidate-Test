output "db_endpoint" {
  description = "Postgres endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "db_port" {
  description = "Postgres port"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Initial database name"
  value       = aws_db_instance.postgres.db_name
}
