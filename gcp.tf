provider "google" {
  alias = "webbie"
  region  = "us-west1"
  zone    = "us-west1-a"
}

data "google_billing_account" "johnrinehart" {
  billing_account = "0175F6-DCC364-FB45AD"
  open         = true
}

resource "google_project" "webbie" {
  billing_account = data.google_billing_account.johnrinehart.id
  name       = "webbie"
  project_id = "webbie-295322"
}

resource "google_storage_bucket" "gce-images" {
  name          = "johnrinehart-gce-images"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = false
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.gce-images.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_compute_instance" "webbie" {
  provider = google-beta
  name     = "webbie"
  zone     = "us-west1-a"
  project = google_project.webbie.project_id

  machine_type = "e2-micro"

  allow_stopping_for_update = true

  #source_machine_image = google_compute_machine_image.johnos.id
  #source_machine_image = data.google_storage_bucket_object.gce-image.name
  #source_machine_image = google_compute_image.johnos.self_link


  boot_disk {
    initialize_params {
      image = google_compute_image.johnos.id
      labels = {
        "project" = "webbie"
        "reason" = "webbie-vm"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    os-login = "FALSE"
    ssh-keys = "john:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ61iahx0HtGVD0qtBFIr8nTPivNxQimrqaloBazYCPK john@nixos"
  }

  // Override fields from machine image
  can_ip_forward = true

  tags = ["headscale"]

  labels = {
    project    = "webbie"
    importance = "1" # 1 to 5, 1 is highest
  }

}

resource "google_compute_firewall" "rules" {
  name        = "allow-80-for-headscale"
  network     =  google_compute_network.default.id
  description = "Allow inbound on 80 for headscale connections"
  project = google_project.webbie.project_id

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["headscale"]
}

resource "google_compute_image" "johnos" {
  name = "johnos"
  project = google_project.webbie.project_id
  raw_disk {
     source = data.google_storage_bucket_object.gce-image.self_link
  }
}

resource "google_compute_network" "default" {
  name = "default"
  description = "Default network for the project"
}

data "google_storage_bucket_object" "gce-image" {
  name   = file("./latest_gce")
  bucket = google_storage_bucket.gce-images.name
}

