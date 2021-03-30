terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.1.4"
    }

    aws = {
      source = "hashicorp/aws"
      version = "3.34.0"
    }
  }

  backend "http" {
    address = "http://localhost:8080"
    lock_address = "http://localhost:8080"
    unlock_address = "http://localhost:8080"
  }

}
