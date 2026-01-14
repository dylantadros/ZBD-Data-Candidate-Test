output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.postgres.port
}

output "rds_username" {
  description = "RDS instance root user name"
  value       = aws_db_instance.postgres.username
}

output "redshift_endpoint" {
  description = "Redshift Serverless endpoint"
  value       = aws_redshiftserverless_workgroup.main.endpoint
}

output "redshift_port" {
  description = "Redshift Serverless port"
  value       = aws_redshiftserverless_workgroup.main.port
}
