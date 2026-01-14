# Terraform AWS (Scaffold)

This folder captures a lightweight Terraform scaffold for a single RDS Postgres instance and a Redshift Serverless workgroup, wired together with a zero-ETL integration.

Key choices are intentionally simple: the default VPC/subnets are used, security groups are permissive by default, and both RDS and Redshift are publicly accessible so anyone from the team can connect without having to manager permissions. A real deployment would need tightening (private subnets, restricted CIDR, and more explicit routing).

RDS is configured with a dedicated parameter group that enables logical replication and the other settings required for a zero-ETL integration. Redshift Serverless is configured with case-sensitive identifiers to preserve table and column naming from the source. A dedicated KMS key is created so the integration can create the necessary grants without relying on account-level defaults, that would inherit defaults from the wrong account.

The integration itself is scoped to the `transactions_db` database via a data filter. The Redshift database `raw_transactions` contains the replicated data.
