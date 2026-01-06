# ** add table to .gitignore once converted to private db **

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}

variable "creator_name" {
  description = "Dylan Tadros"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "candidate-postgres"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "candidate_db"
}

variable "db_username" {
  description = "Master username"
  type        = string
}

variable "db_password" {
  description = "Master password"
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

variable "publicly_accessible" {
  description = "Whether the DB is publicly accessible"
  type        = bool
  default     = true
}

variable "allowed_cidr" {
  description = "CIDR allowed to reach Postgres"
  type        = string
  default     = "0.0.0.0/0"
}
