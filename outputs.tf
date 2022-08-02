# output "es_endpoint" {
#   value = "${aws_opensearch_domain.central_logging_acadian.endpoint}"
# }

output "es_arn" {
  value = "${aws_opensearch_domain.central_logging_acadian.arn}"
}

output "es_domain_id" {
  value = "${aws_opensearch_domain.central_logging_acadian.domain_id}"
}
