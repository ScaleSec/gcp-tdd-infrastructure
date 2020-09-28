provider "google" {
  project     = "scalesec-dev"
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
}
