locals {
  access_logs = var.access_logs != {} ? var.access_logs : {
    bucket  = local.access_logs_bucket_id
    enabled = true
    prefix  = "${var.namespace}/${var.name}"
  }
  access_logs_bucket_id = var.access_logs_bucket_id != "" ? var.access_logs_bucket_id : "${var.environment}-alb-logs-${var.aws_account_id_monitoring}-${var.aws_region}"
  access_logs_prefix    = var.access_logs_prefix != "" ? var.access_logs_prefix : "${var.namespace}_${var.name}"
  access_logs_location  = "s3://${local.access_logs_bucket_id}/${local.access_logs_prefix}/AWSLogs/${var.aws_account_id}/elasticloadbalancing/${var.aws_region}"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.7.0"

  name = "${var.environment}-${var.name}"

  load_balancer_type = var.load_balancer_type
  ip_address_type    = var.ip_address_type

  vpc_id               = var.vpc_id
  subnets              = var.subnets
  security_group_rules = var.security_group_rules

  http_tcp_listeners = var.http_tcp_listeners
  https_listeners    = var.https_listeners

  extra_ssl_certs = var.extra_ssl_certs

  tags = module.this.tags

  access_logs = var.access_logs_enabled ? local.access_logs : {}
}
