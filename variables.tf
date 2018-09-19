# Cluster Name
variable "name_prefix" {}

# Network Name
variable "network" {}

# Instances Self Link
variable "instances_self_link" {
  type = "list"
}

# DCOS Role
variable "dcos_role" {}
