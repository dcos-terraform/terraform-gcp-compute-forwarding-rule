provider "google" {}

# Reserving the Public IP Address of the External Load Balancer for the node
resource "google_compute_address" "node" {
  name = "${var.name_prefix}-ext-${var.dcos_role}-node-addr"
}

# Target Pool for external load balancing access
resource "google_compute_target_pool" "node-pool" {
  name = "${var.name_prefix}-${var.dcos_role}-pool"

  instances = ["${var.instances_self_link}"]

  health_checks = [
    "${google_compute_http_health_check.node-adminrouter-healthcheck.name}",
  ]
}
