GCP Forwarding Rule
============
This module creates an GCP forwarding rule. By default it creats two rules for port 80 and port 443. These could be overwritten by setting `rules`. With `additional_rules` you can specify rules that get applied in additon to 80 and 443

EXAMPLE
-------

```hcl
module "dcos-forwarding-rule" {
  source  = "terraform-dcos/compute-forwarding-rule/gcp"
  version = "~> 0.2.0"

  cluster_name = "production"

  instances_self_link = ["us-central1-a/myinstance1","us-central1-b/myinstance2"]
  additional_rules = [
                      {
                         port_range            = "8080"
                         load_balancing_scheme = "EXTERNAL"
                         ip_protocol           = "TCP"
                      },
                     ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_rules | List of additional rules | list | `<list>` | no |
| cluster\_name | Name of the DC/OS cluster | string | n/a | yes |
| health\_check | Health check definition. Setting partial keys is allowed. E.g. only setting `port` or `request_path` | map | `<map>` | no |
| instances\_self\_link | List of instance self links | list | `<list>` | no |
| labels | Add custom labels to all resources | map | `<map>` | no |
| name\_format | printf style format for naming the ELB. Gets truncated to 32 characters. (input cluster_name) | string | `"%s-load-balancer"` | no |
| rules | List of rules. By default HTTP and HTTPS are set. If set it overrides the default rules. | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| ip\_address | Load balancer ip address |

