terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "4.62.1"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.62.1"
    }

    b2 = {
      source  = "Backblaze/b2"
      version = "0.8.4"
    }
  }

  backend "http" {
    address        = "http://localhost:8080"
    lock_address   = "http://localhost:8080"
    unlock_address = "http://localhost:8080"
  }
}
