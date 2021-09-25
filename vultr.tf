# Configure the Vultr Provider
provider "vultr" {
  api_key = var.vultr_api_key
  rate_limit = 700
  retry_limit = 3
}

resource vultr_iso_private "john_os" {
  url = "https://f000.backblazeb2.com/file/JohnOS-ISOs/johnos_dirty-21.11.20210923.51bcdc4-x86_64-linux.iso"
}
