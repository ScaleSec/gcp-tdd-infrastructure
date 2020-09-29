terraform {
  backend "gcs" {
    bucket = "scalesec-terraform-state"
    prefix = "lnl"
  }
}

provider "google" {
  project     = var.project_id
  region      = "us-west1"
}

resource "google_compute_instance" "scalesec" {
  name = "scalesec-test"
  machine_type = "n1-standard-1"
  zone = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // External IP address is default
    }
  }

  labels = {
    foo = "bar"
  }
}

resource "google_storage_bucket" "state" {
  name = "scalesec-terraform-state"
}
