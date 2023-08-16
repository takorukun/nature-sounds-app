output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}

output "container_definitions" {
  value = local.container_definitions
  sensitive = true
}
