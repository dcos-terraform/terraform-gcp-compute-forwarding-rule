resource "google_compute_forwarding_rule" "pubagt-forwarding-rule-http" {
  count                 = "${var.dcos_role == "pubagt" ? 1 : 0 }"
  name                  = "${var.name_prefix}-${var.dcos_role}-ext-lb-rule-http"
  load_balancing_scheme = "EXTERNAL"
  target                = "${google_compute_target_pool.node-pool.self_link}"
  port_range            = "80"
  ip_address            = "${google_compute_address.node.address}"
  depends_on            = ["google_compute_http_health_check.public-agent-haproxy-healthcheck"]
}

resource "google_compute_forwarding_rule" "pubagt-forwarding-rule-https" {
  count                 = "${var.dcos_role == "pubagt" ? 1 : 0 }"
  name                  = "${var.name_prefix}-${var.dcos_role}-ext-lb-rule-https"
  load_balancing_scheme = "EXTERNAL"
  target                = "${google_compute_target_pool.node-pool.self_link}"
  port_range            = "443"
  ip_address            = "${google_compute_address.node.address}"
  depends_on            = ["google_compute_http_health_check.public-agent-haproxy-healthcheck"]
}

# Used for the external load balancer.
# The external load balancer only supports google_compute_http_health_check resource.
resource "google_compute_http_health_check" "public-agent-haproxy-healthcheck" {
  count        = "${var.dcos_role == "pubagt" ? 1 : 0 }"
  name         = "${var.name_prefix}-ext-http-${var.dcos_role}-haproxy-chk"
  request_path = "/_haproxy_health_check"
  port         = "9090"

  timeout_sec         = 2
  check_interval_sec  = 5
  unhealthy_threshold = 2
  healthy_threshold   = 2
}
