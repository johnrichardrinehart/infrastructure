terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.4.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "3.60.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "3.85.0"
    }

    b2 = {
      source = "Backblaze/b2"
      version = "0.7.0"
    }
  }

  backend "http" {
    address        = "http://localhost:8080"
    lock_address   = "http://localhost:8080"
    unlock_address = "http://localhost:8080"
  }
}
