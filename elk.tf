
resource "aws_opensearch_domain" "central_logging_acadian" { 
  domain_name           = "central-logging-testing-2" 
  engine_version = "OpenSearch_1.2"

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.central_logging_cross_account_els.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  cluster_config {
    instance_type = "r5.large.search"
  }

  ebs_options {
    ebs_enabled = true
    volume_type = "gp2"
    volume_size = 20
  }
  encrypt_at_rest {
    enabled = true
  }
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = var.user_name
      master_user_password = var.user_password
    }
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-0-2019-07"
  }

  vpc_options {
    subnet_ids = var.domain_subnet_ids
    security_group_ids = [aws_security_group.opensearch.id]
  }



  access_policies = data.aws_iam_policy_document.os_access_policies.json

}

data "aws_iam_policy_document" "os_access_policies" {
    statement {
      effect = "Allow"
      principals {
        type = "AWS"
        identifiers = [*]
      }
      actions = [
        "es:ESHttp*"
      ]
      resources = [
        "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/central-logging-testing/*"
      ]
    }
  }



resource "aws_cloudwatch_log_group" "central_logging_cross_account_els" {
    name = "central_logging_cross_account_els"
  }

resource "aws_cloudwatch_log_resource_policy" "central_logging_cross_account_els" {
  policy_name = "central_logging_cross_account_els"
  policy_document = data.aws_iam_policy_document.opensearch_logs.json
}

data "aws_iam_policy_document" "opensearch_logs" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream",
    ]
    resources = [
      "arn:aws:logs:*"
    ]
  }
}
