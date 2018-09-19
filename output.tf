# Cluster Name
output "name_prefix" {
  value = "${var.name_prefix}"
}

# Network Name
output "network" {
  value = "${var.network}"
}

# Instances Self Link
output "instances_self_link" {
  value = "${var.instances_self_link}"
}

# GFE Public IP Address
output "gfe.public_ip" {
  value = "${element(concat(google_compute_forwarding_rule.master-forwarding-rule-http.*.ip_address,
                            google_compute_forwarding_rule.public-agent-forwarding-rule-http.*.ip_address,
                            list("")), 0)}"
}

# target pool
output "target_pool" {
  value = "${element(concat(google_compute_target_pool.master-pool.*.self_link,
                            google_compute_target_pool.node-pool.*.self_link,
                            list("")), 0)}"
}

# DCOS Role
output "dcos_role" {
  value = "${var.dcos_role}"
}
