provider "google" {
  project     = "webbie-295322"
  zone = "us-west1-a"
}

resource google_compute_instance "webbie" {
  name         = "webbie"
  machine_type = "f1-micro"
  zone = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20201112"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  tags = [
    "http-server",
    "https-server",
  ]

  service_account {
          email  = "1038906272696-compute@developer.gserviceaccount.com"
          scopes = [
              "https://www.googleapis.com/auth/devstorage.read_only",
              "https://www.googleapis.com/auth/logging.write",
              "https://www.googleapis.com/auth/monitoring.write",
              "https://www.googleapis.com/auth/service.management.readonly",
              "https://www.googleapis.com/auth/servicecontrol",
              "https://www.googleapis.com/auth/trace.append",
            ] 
        }
}