output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(module.alb.lb_dns_name, "")
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = try(module.alb.lb_zone_id, "")
}
