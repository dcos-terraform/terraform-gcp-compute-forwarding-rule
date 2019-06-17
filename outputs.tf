output "ip_address" {
  description = "Load balancer ip address"
  value       = "${element(google_compute_address.forwarding_rule_address.*.address, 0)}"
}
