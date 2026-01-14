resource "aws_kms_key" "zero_etl" {
  description             = "KMS key for RDS to Redshift zero-ETL"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAccountAdministration"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowRdsAndRedshiftUse"
        Effect = "Allow"
        Principal = {
          Service = [
            "rds.amazonaws.com",
            "redshift.amazonaws.com"
          ]
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "zero_etl" {
  name          = "alias/zero-etl-integration"
  target_key_id = aws_kms_key.zero_etl.key_id
}
