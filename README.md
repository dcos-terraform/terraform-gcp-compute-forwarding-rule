# DC/OS GCP Front End Load Balancer Fowarding Rules

# Usage

```hcl
module "pubagt-frontend-compute-firewall" {
  source  = "dcos-terraform/compute_forwarding_rule/gcp"
  version = "~> 0.0"

  providers = {
    google = "google"
  }

  name_prefix         = "${var.name_prefix}"
  network             = "${data.google_compute_subnetwork.a.network}"
  instances_self_link = "${module.dcos-pubagt-instances.instances_self_link}"
  dcos_role           = "public-agent"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dcos_role | DCOS Role | string | - | yes |
| instances_self_link | Instances Self Link | list | - | yes |
| name_prefix | Cluster Name | string | - | yes |
| network | Network Name | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dcos_role | DCOS Role |
| gfe.public_ip | GFE Public IP Address |
| instances_self_link | Instances Self Link |
| name_prefix | Cluster Name |
| network | Network Name |
