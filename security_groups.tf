data "aws_vpc" "selected" {
  id = var.vpc_id
}


resource "aws_security_group" "opensearch" {
  name = "central-logging-testing-opensearch-domain"
  description = "OpenSearch Domain"
  vpc_id = var.vpc_id

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


}