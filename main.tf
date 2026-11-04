resource "oci_identity_policy" "this" {
  count          = var.identity_policy != null ? 1 : 0
  provider       = oci.home
  compartment_id = var.identity_policy.compartment_id
  description    = var.identity_policy.description
  name           = var.identity_policy.policy_name
  statements     = var.identity_policy.statements
  defined_tags   = var.identity_policy.defined_tags
  freeform_tags  = var.identity_policy.freeform_tags
  version_date   = var.identity_policy.version_date
}

resource "oci_identity_group" "this" {
  count          = var.identity_group != null ? 1 : 0
  provider       = oci.home
  description    = var.identity_group.description
  name           = var.identity_group.name
  compartment_id = var.identity_group.compartment_id
  defined_tags   = var.identity_group.defined_tags
  freeform_tags  = var.identity_group.freeform_tags
}

resource "oci_identity_user" "this" {
  for_each       = var.identity_users != null ? var.identity_users : {}
  provider       = oci.home
  name           = each.value.name == null ? each.key : each.value.name
  description    = each.value.description
  compartment_id = each.value.compartment_id
  email          = each.value.email
  defined_tags   = each.value.defined_tags
  freeform_tags  = each.value.freeform_tags
}

resource "oci_identity_user_group_membership" "this" {
  count          = var.identity_group != null && var.identity_users != null ? 1 : 0
  provider       = oci.home
  group_id       = oci_identity_group.this[0].id
  user_id        = oci_identity_user.this[0].id
  compartment_id = oci_identity_user.this[0].compartment_id
}

resource "oci_identity_user_capabilities_management" "this" {
  for_each                     = var.identity_users != null ? var.identity_users : {}
  provider                     = oci.home
  user_id                      = oci_identity_user.this[each.key].id
  can_use_api_keys             = each.value.capabilities.can_use_api_keys
  can_use_auth_tokens          = each.value.capabilities.can_use_auth_tokens
  can_use_console_password     = each.value.capabilities.can_use_console_password
  can_use_customer_secret_keys = each.value.capabilities.can_use_customer_secret_keys
  can_use_smtp_credentials     = each.value.capabilities.can_use_smtp_credentials
}

resource "oci_identity_compartment" "this" {
  count          = var.compartment != null ? 1 : 0
  provider       = oci.home
  compartment_id = var.compartment.id
  description    = var.compartment.description
  name           = var.compartment.name
  defined_tags   = var.compartment.defined_tags
  freeform_tags  = var.compartment.freeform_tags
  enable_delete  = var.compartment.enable_delete
}

resource "oci_identity_customer_secret_key" "this" {
  for_each = var.identity_users != null ? {
    for k, v in var.identity_users : k => v
    if lookup(v, "customer_secret_key_display_name", null) != null
  } : {}

  depends_on   = [oci_identity_user_capabilities_management.this]
  provider     = oci.home
  display_name = each.value.customer_secret_key_display_name
  user_id      = oci_identity_user.this[each.key].id
}

resource "oci_identity_auth_token" "this" {
  for_each = var.identity_users != null ? {
    for k, v in var.identity_users : k => v
    if lookup(v, "auth_token_description", null) != null
  } : {}

  depends_on  = [oci_identity_user_capabilities_management.this]
  provider    = oci.home
  description = each.value.auth_token_description
  user_id     = oci_identity_user.this[each.key].id
}

resource "oci_identity_domain" "this" {
  count                     = can(var.identity_domain.create) ? 1 : 0
  provider                  = oci.home
  description               = var.identity_domain.description
  compartment_id            = var.identity_domain.compartment_id
  display_name              = var.identity_domain.display_name
  home_region               = var.identity_domain.home_region
  license_type              = var.identity_domain.license_type
  admin_email               = var.identity_domain.admin != null ? var.identity_domain.admin.email : null
  admin_first_name          = var.identity_domain.admin != null ? var.identity_domain.admin.first_name : null
  admin_last_name           = var.identity_domain.admin != null ? var.identity_domain.admin.last_name : null
  admin_user_name           = var.identity_domain.admin != null ? var.identity_domain.admin.last_name : null
  defined_tags              = var.identity_domain.defined_tags
  freeform_tags             = var.identity_domain.freeform_tags
  is_hidden_on_login        = var.identity_domain.is_hidden_on_login
  is_notification_bypassed  = var.identity_domain.is_notification_bypassed
  is_primary_email_required = var.identity_domain.is_primary_email_required
  state                     = var.identity_domain.state
}

resource "oci_identity_api_key" "this" {
  for_each = {
    for k, v in(var.identity_users != null ? var.identity_users : {}) :
    k => v if lookup(v, "create_auth_token", false) == true
  }
  key_value = tls_private_key.this[each.key].id
  user_id   = oci_identity_user.this[each.key].id
}

resource "tls_private_key" "this" {
  for_each = {
    for k, v in(var.identity_users != null ? var.identity_users : {}) :
    k => v if lookup(v, "create_auth_token", false) == true
  }
  algorithm = "ECDSA"
  rsa_bits  = "4096"
}
