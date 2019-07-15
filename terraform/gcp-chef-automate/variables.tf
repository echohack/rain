variable "gcp_credentials_file" {}

variable "gcp_project" {}

variable "gcp_region" {
  default = "us-west1"

  description = <<EOF
Region List: https://cloud.google.com/compute/docs/regions-zones/
EOF
}

variable "gcp_ssh_public_key" {}

variable "gcp_ssh_private_key" {}

///////////////////////////////////////
// Required Labels (aka Tags)
// lower-case, numbers, underscores, or dashes only

variable "label_contact" {}

variable "label_ttl" {
  default = 8
}

///////////////////////////////////////
// Automate Variables

variable "automate_license" {}

variable "automate_hostname" {}

variable "ssh_user" {
  description = "Username of account to create and use for SSH access along with var.gcp_ssh_private_key"
}

variable "dns_zone_name" {
  description = "GCP-managed DNS zone name in which to register automate_hostname"
}

variable "dns_zone_project" {
  default     = "null"
  description = "Project hosting the automate_dns_zone above."
}

variable "automate_machine_type" {
  default = "n1-standard-4"

  description = <<EOF
Machine Types:  https://cloud.google.com/compute/docs/machine-types
EOF
}

variable "email_address" {
  description = "E-mail address used to create acme_registration for Let's Encrypt cert generation"
}

variable "acme_provider_url" {
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"

  description = <<EOF
An API endpoint URL for an ACME-compliant CA.  We default to LetsEncrypt staging endpoint.
This will issue certs, but the certs will not be valid.

For valid certs from LetsEncrypt, use https://acme-v02.api.letsencrypt.org/directory
EOF
}

variable "automate_custom_ssl" {
  default     = "false"
  description = "Enable to configure automate with the below certificate"
}

variable "automate_custom_ssl_private_key" {
  default     = "Paste private key here"
  description = "automate_private_key is the SSL private key that will be used to congfigure HTTPS for automate"
}

variable "automate_custom_ssl_cert_chain" {
  default     = "Paste certificate chain here"
  description = "automate_cert_chain is the SSL certificate chain that will be used to congfigure HTTPS for automate"
}

variable "automate_channel" {
  default     = "current"
  description = "Release channel subscription for automate install and updates"
}
