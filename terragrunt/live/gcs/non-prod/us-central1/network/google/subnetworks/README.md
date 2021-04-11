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
