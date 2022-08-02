#s3 bucket
resource "aws_s3_bucket" "logging-acadian" {
  bucket = "acadian-testing-logging-bucket-development"
}

resource "aws_s3_bucket_acl" "logging_bucket_acadian_acl" {
  bucket = aws_s3_bucket.logging-acadian.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "logging_bucket_acadian_policy" {
  bucket = aws_s3_bucket.logging-acadian.id
  policy = jsonencode({
    Id      = "logging_bucket_policy",
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "bucket_policy_${var.ui_bucket_name}_root",
        Action = ["s3:ListBucket"],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.logging-acadian.arn}",
          "${aws_s3_bucket.logging-acadian.arn}/*"
        ]
        Principal = { "AWS" : "${aws_iam_role.central_logging_acadian.arn}" }
      }
    ]
  })
}
