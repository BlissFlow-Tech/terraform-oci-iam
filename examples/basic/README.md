# Basic example

Creates a group with a policy, and a service user with an auth token, as two module calls. Identity resources go through the `oci.home` provider.

```sh
terraform init
terraform apply -var tenancy_ocid=<tenancy-ocid> -var region=<region> -var home_region=<home-region>
```
