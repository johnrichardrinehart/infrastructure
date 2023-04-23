provider "google" {
  alias = "webbie"
  project = "webbie-295322"
  region  = "us-west1"
  zone    = "us-west1-a"
}

data "google_billing_account" "johnrinehart" {
  billing_account = "0175F6-DCC364-FB45AD"
  #display_name = "John Rinehart Personal Billing Account"
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

  labels = {
    project    = "webbie"
    importance = "1" # 1 to 5, 1 is highest
  }
}

#resource "google_compute_machine_image" "johnos" {
#  provider        = google-beta
#  project = google_project.webbie.project_id
#  #zone = "us-west1"
#  name            = "johnos"
#  source_instance = data.google_storage_bucket_object.gce-image.self_link
#}


resource "google_compute_image" "johnos" {
  name = "johnos"
  project = google_project.webbie.project_id
  source_image = replace(trimsuffix(data.google_storage_bucket_object.gce-image.self_link, ".raw.tar.gz"),"/\\.|_/","-")
}

data "google_storage_bucket_object" "gce-image" {
  name   = "nixos-image-23.05.20230412.6b70761-x86_64-linux.raw.tar.gz"
  bucket = google_storage_bucket.gce-images.name
}

