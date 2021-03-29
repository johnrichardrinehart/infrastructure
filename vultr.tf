
# Configure the Vultr Provider
provider "vultr" {
  api_key = var.vultr_api_key
  rate_limit = 700
  retry_limit = 3
}

# TODO: Support case open about the below which fails with 404 server not found (but server is alive)
resource vultr_iso_private "john_os" {
  url = "https://hydra.johnrinehart.dev/build/18/download/1/nixos.iso"
}

data "vultr_instance" "CloudNix" {
  filter {
    name   = "label"
    values = ["CloudNix"]
  }
}

data "vultr_instance" "MarinaBrave" {
  filter {
    name   = "label"
    values = ["marinabrave"]
  }
} 