# gcp

* [configure-a-service-account](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/beta-private-cluster#configure-a-service-account)
* [prep-kubernetes-engine-for-prod](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod)
* [networking](https://cloud.google.com/solutions/prep-kubernetes-engine-for-prod#configuring_networking)
* [gpus-pricing](https://cloud.google.com/compute/gpus-pricing)
* [gke-how-to-gpus](https://cloud.google.com/kubernetes-engine/docs/how-to/gpus)
* [alias-ips](https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips)
* [pricing](https://cloud.google.com/tpu/pricing)
* [provisioning-anthos-clusters-with-terraform](https://cloud.google.com/solutions/provisioning-anthos-clusters-with-terraform)
* [cloud-nat](https://cloud.google.com/nat/docs/overview)
* [find-your-customer-id](https://support.google.com/a/answer/10070793/find-your-customer-id?hl=en)

# subnetworks

use terraform console to demonstrate usage of cidrsubnet function.

```
terraform console
```

#### subnets

`cluster-${dependency.random_string.outputs.result}`

```
> cidrsubnet("10.0.0.0/16", 4, 0)
"10.0.0.0/20"
```

#### secondary_ranges

`cluster-${dependency.random_string.outputs.result}-secondary-01`

```
> cidrsubnet("10.1.0.0/16", 4, 0)
"10.1.0.0/20"
```

`cluster-${dependency.random_string.outputs.result}-secondary-02`

```
> cidrsubnet("10.1.0.0/16", 4, 1)
"10.1.16.0/20"
```
