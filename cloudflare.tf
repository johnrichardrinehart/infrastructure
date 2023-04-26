provider "cloudflare" {
    api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "www-johnrinehart-dot-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = google_compute_instance.webbie.network_interface.0.access_config.0.nat_ip
  type    = "A"
  ttl     = 1 # TTL must be set to 1 when proxied is true
  proxied = true
}

resource "cloudflare_record" "johnrinehart-dot-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  value   = google_compute_instance.webbie.network_interface.0.access_config.0.nat_ip
  type    = "A"
  ttl     = 1 # TTL must be set to 1 when proxied is true
  proxied = true
}

resource "cloudflare_record" "headscale-dot-johnrinehart-dot-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "headscale"
  value   = google_compute_instance.webbie.network_interface.0.access_config.0.nat_ip
  type    = "A"
  ttl     = 1 # TTL must be set to 1 when proxied is true
  proxied = true
}

resource "cloudflare_record" "bastion-dot-johnrinehart-dot-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "bastion"
  value   = google_compute_instance.webbie.network_interface.0.access_config.0.nat_ip
  type    = "A"
  ttl     = 3600 # TTL must be set to 1 when proxied is true
  proxied = false
}

