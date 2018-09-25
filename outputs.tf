output "ip_address" {
  description = "Load balancer ip address"
  value       = "${google_compute_address.forwarding_rule_address.address}"
}
