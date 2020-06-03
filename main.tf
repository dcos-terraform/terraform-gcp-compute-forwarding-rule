/**
 * GCP Forwarding Rule
 * ============
 * This module creates an GCP forwarding rule. By default it creats two rules for port 80 and port 443. These could be overwritten by setting `rules`. With `additional_rules` you can specify rules that get applied in additon to 80 and 443
 *
 * EXAMPLE
 * -------
 *
 *```hcl
 * module "dcos-forwarding-rule" {
 *   source  = "terraform-dcos/compute-forwarding-rule/gcp"
 *   version = "~> 0.2.0"
 *
 *   cluster_name = "production"
 *
 *   instances_self_link = ["us-central1-a/myinstance1","us-central1-b/myinstance2"]
 *   additional_rules = [
 *                       {
 *                          port_range            = "8080"
 *                          load_balancing_scheme = "EXTERNAL"
 *                          ip_protocol           = "TCP"
 *                       },
 *                      ]
 * }
 *```
 */

provider "google" {
}

locals {
  cluster_name         = var.name_prefix != "" ? "${var.name_prefix}-${var.cluster_name}" : var.cluster_name
  forwarding_rule_name = format(var.name_format, local.cluster_name)

  default_rules = [
    {
      port_range            = "80"
      load_balancing_scheme = "EXTERNAL"
      ip_protocol           = "TCP"
    },
    {
      port_range            = "443"
      load_balancing_scheme = "EXTERNAL"
      ip_protocol           = "TCP"
    },
  ]

  concat_rules = [coalescelist(var.rules, concat(local.default_rules, var.additional_rules))]
}

# Reserving the Public IP Address of the External Load Balancer for the node
resource "google_compute_address" "forwarding_rule_address" {
  count = var.disable ? 0 : 1
  name  = local.forwarding_rule_name
}

resource "google_compute_forwarding_rule" "forwarding_rule_config" {
  count = var.disable ? 0 : length(local.concat_rules)
  name  = "${local.forwarding_rule_name}-${local.concat_rules[count.index]["port_range"]}"

  ip_protocol = lookup(local.concat_rules[count.index], "ip_protocol", "TCP")
  load_balancing_scheme = lookup(
    local.concat_rules[count.index],
    "load_balancing_scheme",
    "EXTERNAL",
  )
  port_range = local.concat_rules[count.index]["port_range"]

  target     = google_compute_target_pool.forwarding_rule_pool[0].self_link
  ip_address = join("", google_compute_address.forwarding_rule_address.*.address)
  depends_on = [google_compute_http_health_check.node-adminrouter-healthcheck]
}

# Target Pool for external load balancing access
resource "google_compute_target_pool" "forwarding_rule_pool" {
  count = var.disable ? 0 : 1
  name  = local.forwarding_rule_name

  instances = var.instances_self_link

  health_checks = [
    google_compute_http_health_check.node-adminrouter-healthcheck[0].name,
  ]
}

# Used for the external load balancer. The external load balancer only supports google_compute_http_health_check resource.
resource "google_compute_http_health_check" "node-adminrouter-healthcheck" {
  count               = var.disable ? 0 : 1
  name                = "${local.forwarding_rule_name}-check"
  check_interval_sec  = lookup(var.health_check, "check_interval_sec", 30)
  timeout_sec         = lookup(var.health_check, "timeout_sec", 5)
  healthy_threshold   = lookup(var.health_check, "healthy_threshold", 2)
  unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 2)
  port                = lookup(var.health_check, "port", "80")
  request_path        = lookup(var.health_check, "request_path", "/")
}

