variable "cluster_name" {
  description = "Name of the DC/OS cluster"
}

variable "name_format" {
  description = "printf style format for naming the ELB. Gets truncated to 32 characters. (input cluster_name)"
  default     = "%s-load-balancer"
}

variable "instances_self_link" {
  description = "List of instance self links"
  type        = "list"
  default     = []
}

variable "rules" {
  description = "List of rules. By default HTTP and HTTPS are set. If set it overrides the default rules."
  default     = []
  type        = "list"
}

variable "additional_rules" {
  description = "List of additional rules"
  default     = []
}

variable "health_check" {
  description = "Health check definition. Setting partial keys is allowed. E.g. only setting `port` or `request_path`"

  default = {
    check_interval_sec  = 30
    timeout_sec         = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "80"
    request_path        = "/"
  }
}

variable "labels" {
  description = "Add custom labels to all resources"
  type        = "map"
  default     = {}
}
