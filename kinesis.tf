resource "aws_kinesis_stream" "central_logging_acadian" {
  name             = var.kinesis_stream_name
  shard_count      = 1
  retention_period = var.Kinesis_stream_retention_period
  tags             = local.tags
}

resource "aws_kinesis_firehose_delivery_stream" "central_logging_acadian" {
  name        = var.kinesis_firehose_name
  destination = "elasticsearch"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.central_logging_acadian.arn
    role_arn           = aws_iam_role.central_logging_acadian.arn
  }

  s3_configuration {
    role_arn           = aws_iam_role.central_logging_acadian.arn
    bucket_arn         = aws_s3_bucket.logging-acadian.arn
    compression_format = "GZIP"
    buffer_size        = 5
    buffer_interval    = 60
  }

  elasticsearch_configuration {
    domain_arn     = aws_opensearch_domain.central_logging_acadian.arn
    role_arn       = aws_iam_role.central_logging_acadian.arn
    index_name     = "central_logging_acadian"
    s3_backup_mode = "AllDocuments"
    retry_duration = 300

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_central_logging_acadian.name
      log_stream_name = "S3Delivery"
    }
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "firehose_central_logging_acadian" {
  name              = "/aws/kinesisfirehose/${local.kinesis_name}"
  retention_in_days = 30
  tags              = local.tags
}
