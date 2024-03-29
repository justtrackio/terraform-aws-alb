locals {
  access_logs = var.access_logs != null ? var.access_logs : {
    bucket  = local.access_logs_bucket_id
    enabled = var.access_logs_enabled
    prefix  = "${module.this.namespace}/${var.name}"
  }
  access_logs_bucket_id = var.access_logs_bucket_id != "" ? var.access_logs_bucket_id : "${module.this.organizational_unit}-monitoring-alb-logs-${var.aws_account_id_monitoring}-${module.this.aws_region}"
  access_logs_prefix    = var.access_logs_prefix != "" ? var.access_logs_prefix : "${module.this.namespace}/${var.name}"
  access_logs_location  = "s3://${local.access_logs_bucket_id}/${local.access_logs_prefix}/AWSLogs/${module.this.aws_account_id}/elasticloadbalancing/${module.this.aws_region}"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "8.7.0"

  name = module.alb_label.id

  access_logs             = var.access_logs_enabled ? local.access_logs : {}
  enable_xff_client_port  = var.enable_xff_client_port
  extra_ssl_certs         = var.extra_ssl_certs
  http_tcp_listeners      = var.http_tcp_listeners
  http_tcp_listener_rules = var.http_tcp_listener_rules
  https_listeners         = var.https_listeners
  https_listener_rules    = var.https_listener_rules
  ip_address_type         = var.ip_address_type
  idle_timeout            = var.idle_timeout
  load_balancer_type      = var.load_balancer_type
  security_group_rules    = var.security_group_rules
  subnets                 = var.subnets
  vpc_id                  = var.vpc_id

  tags = module.alb_label.tags
}
