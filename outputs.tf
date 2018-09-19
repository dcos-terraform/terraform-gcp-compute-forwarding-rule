output "ip_address" {
  description = "IP Address of master load balancer"
  value       = "${google_compute_address.forwarding_rule_address.address}"
}
