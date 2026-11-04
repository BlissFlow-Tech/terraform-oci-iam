# terraform-oci-iam

Terraform module that manages OCI identity: a compartment, a group, users with capabilities and credentials, a policy and an identity domain.

## Usage

```hcl
provider "oci" {
  alias  = "home"
  region = var.home_region
}

module "iam_group" {
  source  = "blissflow-tech/iam/oci"
  version = "~> 1.0"

  providers = {
    oci      = oci
    oci.home = oci.home
  }

  identity_group = {
    name           = "ci-deployers"
    description    = "Service users that push container images"
    compartment_id = var.tenancy_ocid
  }

  identity_policy = {
    compartment_id = var.tenancy_ocid
    policy_name    = "ci-deployers-ocir"
    description    = "Let CI deployers push images"
    statements = [
      "Allow group ci-deployers to manage repos in tenancy",
    ]
  }
}

module "iam_user" {
  source  = "blissflow-tech/iam/oci"
  version = "~> 1.0"

  providers = {
    oci      = oci
    oci.home = oci.home
  }

  identity_users = {
    ci-deployer = {
      description            = "CI image pusher"
      email                  = "ci@example.com"
      compartment_id         = var.tenancy_ocid
      auth_token_description = "registry login"
      capabilities = {
        can_use_auth_tokens = true
      }
    }
  }
}
```

## Notes

* OCI only accepts identity writes in the tenancy's home region, so the module needs an `oci.home` provider alias pointing there. Every identity resource except the API key goes through it.
* Users are keyed by user name; set `name` to use a different one.
* When `identity_group` and `identity_users` are set in the same call, every user joins the group.
* A user gets a customer secret key when `customer_secret_key_display_name` is set, an auth token when `auth_token_description` is set, and a generated API key when `create_auth_token = true`.
* The `identity_users` output is sensitive because it carries the secret key and auth token values.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.3 |
| oci | >= 8.0, < 10.0 |
| tls | >= 4.0, < 5.0 |

## Providers

| Name | Version |
| ---- | ------- |
| oci | >= 8.0, < 10.0 |
| oci.home | >= 8.0, < 10.0 |
| tls | >= 4.0, < 5.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [oci_identity_api_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_api_key) | resource |
| [oci_identity_auth_token.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_auth_token) | resource |
| [oci_identity_compartment.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_identity_customer_secret_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_customer_secret_key) | resource |
| [oci_identity_domain.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_domain) | resource |
| [oci_identity_group.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_group) | resource |
| [oci_identity_policy.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_identity_user.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user) | resource |
| [oci_identity_user_capabilities_management.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user_capabilities_management) | resource |
| [oci_identity_user_group_membership.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user_group_membership) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| compartment | Compartment to create under the parent compartment id | <pre>object({<br/>    name          = string<br/>    id            = string<br/>    description   = string<br/>    defined_tags  = optional(map(string))<br/>    freeform_tags = optional(map(string))<br/>    enable_delete = optional(bool, false)<br/>  })</pre> | `null` | no |
| identity\_domain | Identity domain to create | <pre>object({<br/>    create         = optional(bool, false)<br/>    description    = string<br/>    compartment_id = string<br/>    display_name   = string<br/>    home_region    = string<br/>    license_type   = optional(string, "free")<br/>    admin = optional(object({<br/>      email      = optional(string)<br/>      first_name = optional(string)<br/>      last_name  = optional(string)<br/>      user_name  = optional(string)<br/>    }))<br/>    defined_tags              = optional(map(string))<br/>    freeform_tags             = optional(map(string))<br/>    is_hidden_on_login        = optional(bool)<br/>    is_notification_bypassed  = optional(bool)<br/>    is_primary_email_required = optional(bool)<br/>    state                     = optional(string)<br/>  })</pre> | `null` | no |
| identity\_group | Group to create | <pre>object({<br/>    name           = string<br/>    description    = string<br/>    compartment_id = string<br/>    defined_tags   = optional(map(string))<br/>    freeform_tags  = optional(map(string))<br/>  })</pre> | `null` | no |
| identity\_policy | Policy to create in the home region. Null creates none. | <pre>object({<br/>    compartment_id = string<br/>    description    = string<br/>    policy_name    = string<br/>    statements     = list(string)<br/>    defined_tags   = optional(map(string))<br/>    freeform_tags  = optional(map(string))<br/>    version_date   = optional(string)<br/>  })</pre> | `null` | no |
| identity\_users | Users to create, keyed by user name unless name is set, with optional capabilities, customer secret key, auth token and API key | <pre>map(object({<br/>    name              = optional(string)<br/>    compartment_id    = optional(string)<br/>    description       = optional(string)<br/>    email             = optional(string)<br/>    defined_tags      = optional(map(string))<br/>    freeform_tags     = optional(map(string))<br/>    create_auth_token = optional(bool)<br/>    capabilities = optional(object({<br/>      can_use_api_keys             = optional(bool, false)<br/>      can_use_auth_tokens          = optional(bool, false)<br/>      can_use_console_password     = optional(bool, false)<br/>      can_use_customer_secret_keys = optional(bool, false)<br/>      can_use_smtp_credentials     = optional(bool, false)<br/>    }))<br/>    customer_secret_key_display_name = optional(string)<br/>    auth_token_description           = optional(string)<br/>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| compartment | The compartment created, or null |
| domain | The identity domain created, or null |
| identity\_group | The group created, or null |
| identity\_policy | The policy created, or null |
| identity\_users | Detailed information for all managed identity users, including their keys and tokens. |
| user\_group\_attachment | The group memberships created, keyed like identity\_users |
<!-- END_TF_DOCS -->

## License

Apache 2.0. See [LICENSE](LICENSE).
