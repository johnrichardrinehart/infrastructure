# manage the terraform.state for all managed infrastructure
data "b2_bucket" "terraform" {
  bucket_name = "terraform-manager"
}

resource "b2_bucket" "isos" {
  bucket_name = "JohnOS-ISOs"
  bucket_type = "allPublic"
}

resource "b2_bucket" "nix-store" {
  bucket_name = "my-nix-store"
  bucket_type = "allPrivate"
}
