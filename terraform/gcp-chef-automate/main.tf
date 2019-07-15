provider "google" {
  credentials = "${file("${var.gcp_credentials_file}")}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

resource "random_id" "instance_id" {
  byte_length = 4
}

data "google_compute_zones" "available" {}

data "google_dns_managed_zone" "chef-demo" {
  project = "${var.dns_zone_project}"
  name    = "${var.dns_zone_name}"
}

locals {
  // GCP returns a trailing '.' from the managed zone data that needs to be stripped
  fqdn = "${var.automate_hostname}.${substr(data.google_dns_managed_zone.chef-demo.dns_name, 0, length(data.google_dns_managed_zone.chef-demo.dns_name) - 1)}"
}

resource "google_compute_network" "a2_network" {
  name = "a2-network-${random_id.instance_id.hex}"
}

data "google_compute_subnetwork" "a2_subnetwork" {
  name = "${google_compute_network.a2_network.name}"
}

resource "google_compute_firewall" "a2_firewall_ingress" {
  name      = "a2-firewall-ingress-${random_id.instance_id.hex}"
  network   = "${google_compute_network.a2_network.name}"
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }
}

resource "google_compute_firewall" "a2_firewall_egress" {
  name      = "a2-firewall-egress-${random_id.instance_id.hex}"
  network   = "${google_compute_network.a2_network.name}"
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
}

resource "google_compute_firewall" "a2_firewall_internal" {
  name          = "a2-firewall-internal-${random_id.instance_id.hex}"
  network       = "${google_compute_network.a2_network.name}"
  direction     = "INGRESS"
  source_ranges = ["${data.google_compute_subnetwork.a2_subnetwork.ip_cidr_range}"]

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }
}
