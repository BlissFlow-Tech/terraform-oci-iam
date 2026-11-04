provider "oci" {
  region = var.region
}

provider "oci" {
  alias  = "home"
  region = var.home_region
}

module "iam_group" {
  source = "../.."

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
  source = "../.."

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
