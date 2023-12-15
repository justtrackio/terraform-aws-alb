module "alb_label" {
  source  = "justtrackio/label/null"
  version = "0.26.0"

  context     = module.this.context
  label_order = var.label_orders.ec2
}
