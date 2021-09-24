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
  label = "hydra"
}

resource "vultr_instance" "MarinaBrave" {
  region="ams"
  plan = "vhf-1c-1gb"
  enable_ipv6 = true
}

# .atku'ila is lojban for Eagle
# https://www.reddit.com/r/lojban/comments/nh3bb6/translation_request/
resource "vultr_instance" "atkuila" {
  region = "ewr"
  plan = "vc2-1c-2gb"
  enable_ipv6 = true
  iso_id = "0eaece5e-6e59-4ef8-8b84-28f4d4c11fb0" # ubuntu 18.04

  label = "atkuila"
}

resource "vultr_block_storage" "atkuila-store" {
    size_gb = 100
    region = "ewr"

    attached_to_instance = vultr_instance.atkuila.id
    label = "atkuila-store"
}
