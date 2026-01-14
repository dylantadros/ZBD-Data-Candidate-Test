resource "aws_security_group" "redshift" {
  name        = "${var.redshift_workgroup_name}-sg"
  description = "Allow Redshift access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Redshift"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "postgres_from_redshift" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.redshift.id
  description              = "Postgres access from Redshift"
}

data "aws_caller_identity" "current" {}

resource "aws_redshiftserverless_namespace" "main" {
  namespace_name      = var.redshift_namespace_name
  db_name             = var.redshift_db_name
  admin_username      = var.redshift_admin_username
  admin_user_password = var.redshift_admin_password
}

resource "aws_redshiftserverless_workgroup" "main" {
  workgroup_name      = var.redshift_workgroup_name
  namespace_name      = aws_redshiftserverless_namespace.main.namespace_name
  base_capacity       = var.redshift_base_capacity
  subnet_ids          = data.aws_subnets.default.ids
  security_group_ids  = [aws_security_group.redshift.id]
  publicly_accessible = true

  config_parameter {
    parameter_key   = "auto_mv"
    parameter_value = "true"
  }

  config_parameter {
    parameter_key   = "datestyle"
    parameter_value = "ISO, MDY"
  }

  config_parameter {
    parameter_key   = "enable_user_activity_logging"
    parameter_value = "true"
  }

  config_parameter {
    parameter_key   = "enable_case_sensitive_identifier"
    parameter_value = "true"
  }

  config_parameter {
    parameter_key   = "max_query_execution_time"
    parameter_value = "14400"
  }

  config_parameter {
    parameter_key   = "query_group"
    parameter_value = "default"
  }

  config_parameter {
    parameter_key   = "require_ssl"
    parameter_value = "true"
  }

  config_parameter {
    parameter_key   = "search_path"
    parameter_value = "$user, public"
  }

  config_parameter {
    parameter_key   = "use_fips_ssl"
    parameter_value = "false"
  }
}

resource "aws_redshift_resource_policy" "zero_etl" {
  resource_arn = aws_redshiftserverless_namespace.main.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "redshift:CreateInboundIntegration"
        Resource = aws_redshiftserverless_namespace.main.arn
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "redshift:AuthorizeInboundIntegration"
        Condition = {
          StringEquals = {
            "aws:SourceArn" = aws_db_instance.postgres.arn
          }
        }
      }
    ]
  })
}

resource "aws_rds_integration" "zero_etl" {
  integration_name = var.zero_etl_integration_name
  source_arn       = aws_db_instance.postgres.arn
  target_arn       = aws_redshiftserverless_namespace.main.arn
  data_filter      = "include: ${var.pg_db_name}.*.*"
  kms_key_id       = aws_kms_key.zero_etl.arn

  depends_on = [aws_redshift_resource_policy.zero_etl]
}
