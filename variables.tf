variable "identity_policy" {
  description = "Policy to create in the home region. Null creates none."
  type = object({
    compartment_id = string
    description    = string
    policy_name    = string
    statements     = list(string)
    defined_tags   = optional(map(string))
    freeform_tags  = optional(map(string))
    version_date   = optional(string)
  })
  default = null
}

variable "identity_users" {
  description = "Users to create, keyed by user name unless name is set, with optional capabilities, customer secret key, auth token and API key"
  type = map(object({
    name              = optional(string)
    compartment_id    = optional(string)
    description       = optional(string)
    email             = optional(string)
    defined_tags      = optional(map(string))
    freeform_tags     = optional(map(string))
    create_auth_token = optional(bool)
    capabilities = optional(object({
      can_use_api_keys             = optional(bool, false)
      can_use_auth_tokens          = optional(bool, false)
      can_use_console_password     = optional(bool, false)
      can_use_customer_secret_keys = optional(bool, false)
      can_use_smtp_credentials     = optional(bool, false)
    }))
    customer_secret_key_display_name = optional(string)
    auth_token_description           = optional(string)
  }))
  default = null
}

variable "identity_group" {
  description = "Group to create"
  type = object({
    name           = string
    description    = string
    compartment_id = string
    defined_tags   = optional(map(string))
    freeform_tags  = optional(map(string))
  })
  default = null
}

variable "compartment" {
  description = "Compartment to create under the parent compartment id"
  type = object({
    name          = string
    id            = string
    description   = string
    defined_tags  = optional(map(string))
    freeform_tags = optional(map(string))
    enable_delete = optional(bool, false)
  })
  default = null
}

variable "identity_domain" {
  description = "Identity domain to create"
  type = object({
    create         = optional(bool, false)
    description    = string
    compartment_id = string
    display_name   = string
    home_region    = string
    license_type   = optional(string, "free")
    admin = optional(object({
      email      = optional(string)
      first_name = optional(string)
      last_name  = optional(string)
      user_name  = optional(string)
    }))
    defined_tags              = optional(map(string))
    freeform_tags             = optional(map(string))
    is_hidden_on_login        = optional(bool)
    is_notification_bypassed  = optional(bool)
    is_primary_email_required = optional(bool)
    state                     = optional(string)
  })
  default = null
}
