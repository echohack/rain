output "chef_automate_public_ip" {
  value = "${google_compute_instance.a2.network_interface.0.access_config.0.nat_ip}"
}

output "chef_automate_url" {
  value = "https://${substr(google_dns_record_set.a2_dns.name, 0, length(google_dns_record_set.a2_dns.name) - 1)}"
}
