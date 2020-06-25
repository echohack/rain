////////////////////////////////
// Required variables. Create a terraform.tfvars.

variable "tag_contact_name" {
  description = "The name associated with the resource. Used to contact if problems occur."
}

variable "tag_contact_email" {
  description = "The email address associated with the person or team that is standing up this resource. Used to contact if problems occur."
}

////////////////////////////////
// AZURE

# variable "ssh_user" {
#   default     = "centos"
#   description = "The user used for SSH connections and path variables."
# }
