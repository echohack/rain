provider "acme" {
  server_url = "${var.acme_provider_url}"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "${var.email_address}"
}

resource "acme_certificate" "a2_cert" {
  account_key_pem = "${acme_registration.reg.account_key_pem}"
  common_name     = "${local.fqdn}"
  depends_on      = ["google_dns_record_set.a2_dns"]

  dns_challenge {
    provider = "gcloud"

    config {
      GCE_PROJECT              = "${var.dns_zone_project}"
      GCE_SERVICE_ACCOUNT_FILE = "${var.gcp_credentials_file}"
    }
  }
}
