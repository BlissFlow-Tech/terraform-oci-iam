output "identity_policy" {
  description = "The policy created, or null"
  value = length(oci_identity_policy.this) > 0 ? {
    compartment_id = one(oci_identity_policy.this[*].compartment_id)
    policy_name    = one(oci_identity_policy.this[*].name)
    defined_tags   = one(oci_identity_policy.this[*].defined_tags)
    freeform_tags  = one(oci_identity_policy.this[*].freeform_tags)
    description    = one(oci_identity_policy.this[*].description)
    id             = one(oci_identity_policy.this[*].id)
    inactive_state = one(oci_identity_policy.this[*].inactive_state)
    state          = one(oci_identity_policy.this[*].state)
    statements     = one(oci_identity_policy.this[*].statements)
    time_created   = one(oci_identity_policy.this[*].time_created)
    version_date   = one(oci_identity_policy.this[*].version_date)
  } : null
}

output "identity_users" {
  description = "Detailed information for all managed identity users, including their keys and tokens."
  sensitive   = true
  value = {
    for k, user in oci_identity_user.this : k => {
      user_name                      = user.name
      id                             = user.id
      identity_provider_id           = user.identity_provider_id
      description                    = user.description
      compartment_id                 = user.compartment_id
      email                          = user.email
      external_identifier            = user.external_identifier
      capabilities                   = user.capabilities
      db_user_name                   = user.db_user_name
      defined_tags                   = user.defined_tags
      freeform_tags                  = user.freeform_tags
      inactive_state                 = user.inactive_state
      last_successful_login_time     = user.last_successful_login_time
      previous_successful_login_time = user.previous_successful_login_time
      state                          = user.state
      time_created                   = user.time_created

      customer_secret_key = contains(keys(oci_identity_customer_secret_key.this), k) ? {
        id             = oci_identity_customer_secret_key.this[k].id
        user_id        = oci_identity_customer_secret_key.this[k].user_id
        inactive_state = oci_identity_customer_secret_key.this[k].inactive_state
        state          = oci_identity_customer_secret_key.this[k].state
        key            = oci_identity_customer_secret_key.this[k].key
        time_created   = oci_identity_customer_secret_key.this[k].time_created
        time_expires   = oci_identity_customer_secret_key.this[k].time_expires
      } : null

      identity_auth_token = contains(keys(oci_identity_api_key.this), k) ? {
        id          = oci_identity_api_key.this[k].id
        fingerprint = oci_identity_api_key.this[k].fingerprint
        key_value   = oci_identity_api_key.this[k].key_value
        user_id     = oci_identity_api_key.this[k].user_id
      } : null
    }
  }
}
output "identity_group" {
  description = "The group created, or null"
  value = length(oci_identity_group.this) > 0 ? {
    name           = one(oci_identity_group.this[*].name)
    description    = one(oci_identity_group.this[*].description)
    compartment_id = one(oci_identity_group.this[*].compartment_id)
    id             = one(oci_identity_group.this[*].id)
    freeform_tags  = one(oci_identity_group.this[*].freeform_tags)
    defined_tags   = one(oci_identity_group.this[*].defined_tags)
    time_created   = one(oci_identity_group.this[*].time_created)
    state          = one(oci_identity_group.this[*].state)
    inactive_state = one(oci_identity_group.this[*].inactive_state)
  } : null
}

output "user_group_attachment" {
  description = "The group memberships created, keyed like identity_users"
  value = {
    for k, m in oci_identity_user_group_membership.this : k => {
      user_id        = m.user_id
      group_id       = m.group_id
      compartment_id = m.compartment_id
      id             = m.id
      inactive_state = m.inactive_state
      state          = m.state
      time_created   = m.time_created
    }
  }
}


output "compartment" {
  description = "The compartment created, or null"
  value = length(oci_identity_compartment.this) > 0 ? {
    root_compartment_id = one(oci_identity_compartment.this[*].compartment_id)
    id                  = one(oci_identity_compartment.this[*].id)
    name                = one(oci_identity_compartment.this[*].name)
    freeform_tags       = one(oci_identity_compartment.this[*].freeform_tags)
    description         = one(oci_identity_compartment.this[*].description)
    inactive_state      = one(oci_identity_compartment.this[*].inactive_state)
    is_accessible       = one(oci_identity_compartment.this[*].is_accessible)
    defined_tags        = one(oci_identity_compartment.this[*].defined_tags)
    state               = one(oci_identity_compartment.this[*].state)
    time_created        = one(oci_identity_compartment.this[*].time_created)
  } : null
}

output "domain" {
  description = "The identity domain created, or null"
  value = length(oci_identity_domain.this) > 0 ? {
    root_compartment_id       = one(oci_identity_domain.this[*].compartment_id)
    id                        = one(oci_identity_domain.this[*].id)
    display_name              = one(oci_identity_domain.this[*].display_name)
    freeform_tags             = one(oci_identity_domain.this[*].freeform_tags)
    description               = one(oci_identity_domain.this[*].description)
    inactive_state            = one(oci_identity_domain.this[*].state)
    time_created              = one(oci_identity_domain.this[*].time_created)
    defined_tags              = one(oci_identity_domain.this[*].defined_tags)
    state                     = one(oci_identity_domain.this[*].state)
    admin_first_name          = one(oci_identity_domain.this[*].admin_first_name)
    admin_last_name           = one(oci_identity_domain.this[*].admin_last_name)
    admin_email               = one(oci_identity_domain.this[*].admin_email)
    admin_user_name           = one(oci_identity_domain.this[*].admin_user_name)
    url                       = one(oci_identity_domain.this[*].url)
    replica_regions           = one(oci_identity_domain.this[*].replica_regions)
    type                      = one(oci_identity_domain.this[*].type)
    lifecycle_details         = one(oci_identity_domain.this[*].lifecycle_details)
    license_type              = one(oci_identity_domain.this[*].license_type)
    is_notification_bypassed  = one(oci_identity_domain.this[*].is_notification_bypassed)
    is_hidden_on_login        = one(oci_identity_domain.this[*].is_hidden_on_login)
    home_region_url           = one(oci_identity_domain.this[*].home_region_url)
    is_primary_email_required = one(oci_identity_domain.this[*].is_primary_email_required)
  } : null
}
