resource "aws_iam_role" "central_logging_acadian" {
  name               = "ES_role_for_S3"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "central_logging_acadian" {
  name   = "central-logging"
  role   = aws_iam_role.central_logging_acadian.id
  policy = data.aws_iam_policy_document.policy_central_logging_acadian.json
}

data "aws_iam_policy_document" "policy_central_logging_acadian" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:AbortMultipartUpload",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.logging-acadian.arn}",
      "${aws_s3_bucket.logging-acadian.arn}/*",
    ]
  }

  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListStreams",
    ]
    effect = "Allow"
    resources = [
      "${aws_kinesis_stream.central_logging_acadian.arn}",
      "${aws_kinesis_stream.central_logging_acadian.arn}/*"
    ]
  }

  statement {
    actions = [
      "es:DescribeOpensearchDomain", ## For Opensearch
      "es:DescribeOpensearchDomains", ## For Opensearch
      "es:DescribeOpensearchDomainConfig", ## For Opensearch
      "es:DescribeDomain", ## For OpenSearch
      "es:DescribeDomains", ## For OpenSearch
      "es:DescribeDomainConfig", ## For OpenSearch
      "es:ESHttpPost",
      "es:ESHttpPut"
    ]
    effect  = "Allow"
    resources = [
      "${aws_opensearch_domain.central_logging_acadian.arn}",
      "${aws_opensearch_domain.central_logging_acadian.arn}/*"
    ]
  }

  statement {
    actions = [
      "es:ESHttpGet"
    ]
    effect  = "Allow"
    resources = [
      "${aws_opensearch_domain.central_logging_acadian.arn}/_all/_settings",
      "${aws_opensearch_domain.central_logging_acadian.arn}/_cluster/stats",
      "${aws_opensearch_domain.central_logging_acadian.arn}/*/_mapping/logs",
      "${aws_opensearch_domain.central_logging_acadian.arn}/_nodes",
      "${aws_opensearch_domain.central_logging_acadian.arn}/_nodes/stats",
      "${aws_opensearch_domain.central_logging_acadian.arn}/_nodes/*/stats",
      "${aws_opensearch_domain.central_logging_acadian.arn}/_stats",
      "${aws_opensearch_domain.central_logging_acadian.arn}/*/_stats"
    ]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/${var.encrypt_at_rest_kms_key_id}"
    ]
  }
}
