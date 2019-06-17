output "ip_address" {
  description = "Load balancer ip address"
  value       = "${length(google_compute_address.forwarding_rule_address.*.address) == 1 ? join("", google_compute_address.forwarding_rule_address.*.address) : element(google_compute_address.forwarding_rule_address.*.address, 0)}"
}
