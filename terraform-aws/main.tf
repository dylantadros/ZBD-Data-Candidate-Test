resource "aws_db_instance" "postgres" {
  identifier        = var.pg_identifier
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  engine            = "postgres"
  engine_version    = "17.7"
  username          = var.pg_username
  password          = var.pg_password
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  publicly_accessible    = true
  skip_final_snapshot = true
  db_name             = var.pg_db_name
  allow_major_version_upgrade = false
  multi_az                    = false
  apply_immediately           = true
  port                        = 5432
  storage_type                = "gp3"
  deletion_protection         = false
  backup_retention_period     = var.backup_retention_period
  parameter_group_name        = aws_db_parameter_group.postgres_zero_etl.name
}

resource "aws_db_parameter_group" "postgres_zero_etl" {
  name        = "${var.pg_identifier}-zero-etl"
  family      = "postgres17"
  description = "Postgres parameters for zero-ETL"

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "rds.replica_identity_full"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "session_replication_role"
    value        = "origin"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "wal_sender_timeout"
    value        = "20000"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_wal_senders"
    value        = "20"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_replication_slots"
    value        = "20"
    apply_method = "pending-reboot"
  }
}
