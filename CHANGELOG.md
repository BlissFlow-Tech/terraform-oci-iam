# Changelog

## [2.0.0](https://github.com/BlissFlow-Tech/terraform-oci-iam/compare/v1.0.0...v2.0.0) (2026-11-04)


### ⚠ BREAKING CHANGES

* set the domain admin user name from admin.user_name
* set the domain license type from identity_domain.license_type
* create the identity domain only when identity_domain.create is true
* add every user to the group when identity_group and identity_users are both set

### Bug Fixes

* add every user to the group when identity_group and identity_users are both set ([fe454a9](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/fe454a9aeeda1e462569244d0f838130fd0ebe28))
* create the identity domain only when identity_domain.create is true ([a3e41d7](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/a3e41d7479670119bd074e40e144c59b490537fd))
* generate a usable RSA API key and return its private key ([e2702f2](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/e2702f2c4fbd43e59d494c569567f312badb0371))
* generate a usable RSA API key and return its private key ([824259e](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/824259e95cba565a2ed5d33fbdcf83661f0b09a2))
* return the auth token in the identity_users output ([ab50c03](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/ab50c039d0cf649673d3b4d5035e08bbcfbc3b49))
* return the auth token in the identity_users output ([5e42230](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/5e42230292a1d03d9442927c5b3bd12c7e6bd26a))
* set the domain admin user name from admin.user_name ([ce78f7c](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/ce78f7c39554f11fe1f644a13e024547982ede3b))
* set the domain license type from identity_domain.license_type ([1842c91](https://github.com/BlissFlow-Tech/terraform-oci-iam/commit/1842c910771276aca3e7f87a8eb6c90532c864f8))
