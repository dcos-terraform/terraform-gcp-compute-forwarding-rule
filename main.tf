provider "google" {}

# Reserving the Public IP Address of the External Load Balancer for the node
resource "google_compute_address" "node" {
  name = "${var.name_prefix}-ext-${var.dcos_role}-node-addr"
}
