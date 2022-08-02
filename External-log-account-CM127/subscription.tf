
resource "aws_cloudwatch_log_subscription_filter" "central-logging" {
  name           = "central-logging-cross-Account"
  log_group_name = "${var.log_group_name}"
  filter_pattern = ""

  #Account Destination
  destination_arn = "arn:aws:logs:${data.aws_region.current.name}:${var.accountid}:destination:central-logging"
  distribution    = "Random"
}
