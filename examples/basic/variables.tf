variable "tenancy_ocid" {
  description = "OCID of the tenancy"
  type        = string
}

variable "region" {
  description = "Region the rest of the configuration runs in"
  type        = string
}

variable "home_region" {
  description = "Home region of the tenancy, where identity resources are written"
  type        = string
}
