# Configure the Vultr Provider
provider "vultr" {
  api_key = var.vultr_api_key
  rate_limit = 700
  retry_limit = 3
}

# TODO: Support case open about the below which fails with 404 server not found (but server is alive)
resource vultr_iso_private "john_os" {
  url = "https://hydra.johnrinehart.dev/build/25/download/1/nixos.iso"
}

resource "vultr_instance" "CloudNix" {
  region="ewr"
  plan = "vc2-1c-1gb"
  enable_ipv6 = true
}

resource "vultr_instance" "MarinaBrave" {
  region="ams"
  plan = "vhf-1c-1gb"
  enable_ipv6 = true
}
