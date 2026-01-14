variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}

variable "creator_name" {
  description = "Tag value for creator"
  type        = string
}

variable "pg_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "candidate-postgres"
}

variable "pg_db_name" {
  description = "Initial database name"
  type        = string
  default     = "transactions_db"
}

variable "pg_username" {
  description = "RDS master username"
  type        = string
}

variable "pg_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage in GB"
  type        = number
  default     = 20
}

variable "allowed_cidr" {
  description = "CIDR allowed to reach RDS and Redshift"
  type        = string
  default     = "0.0.0.0/0"
}

variable "backup_retention_period" {
  description = "RDS automated backup retention in days"
  type        = number
  default     = 1
}

variable "redshift_namespace_name" {
  description = "Redshift Serverless namespace name"
  type        = string
  default     = "transactions-namespace"
}

variable "redshift_workgroup_name" {
  description = "Redshift Serverless workgroup name"
  type        = string
  default     = "transactions-workgroup"
}

variable "redshift_db_name" {
  description = "Redshift Serverless database name"
  type        = string
  default     = "transactions_dw"
}

variable "redshift_admin_username" {
  description = "Redshift Serverless admin username"
  type        = string
}

variable "redshift_admin_password" {
  description = "Redshift Serverless admin password"
  type        = string
  sensitive   = true
}

variable "redshift_base_capacity" {
  description = "Redshift Serverless base capacity in RPUs"
  type        = number
  default     = 8
}

variable "zero_etl_integration_name" {
  description = "Zero-ETL integration name"
  type        = string
  default     = "transactions-zero-etl"
}
