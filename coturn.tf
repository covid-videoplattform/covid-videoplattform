resource "google_compute_address" "coturn_ip_address" {
  name = "coturn-ip-address"
}

resource "google_compute_instance" "coturn" {
  name         = "coturn"
  machine_type = "g1-small"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  metadata = {
    ssh-keys = "root:${file(".ssh/buildbot.pub")}"
  }

  network_interface {
    network = google_compute_network.videoplattform_network.self_link
    access_config {
      nat_ip = google_compute_address.coturn_ip_address.address
    }
  }

  allow_stopping_for_update = true
}

locals {
  turn_servers_ansible_inventory = {
    hosts = {
      coturn = {
        internal_ip = google_compute_instance.coturn.network_interface[0].network_ip
        external_ip = google_compute_instance.coturn.network_interface[0].access_config[0].nat_ip
      }
    }
  }
}
