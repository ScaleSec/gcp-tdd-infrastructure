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

module "instance_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  names         = ["custom-instance-sa"]
  display_name  = "Test Instance Service Account"
  description   = "The Service Account used by Our Test Instance"
  project_roles = ["${var.project_id}=>roles/secretmanager.secretAccessor"]
}

resource "google_compute_instance" "scalesec" {
  name         = "scalesec-test"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"
  project      = var.project_id

  // For quick service account updates. Otherwise the instance will be terminated/rebuilt
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config { }
  }

  labels = {
    // commenting one of the below or changing the value to an invalid value will fail the test
    environment         = "test"
    data_classification = "public"
  }

  service_account {
    email  = module.instance_service_account.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

