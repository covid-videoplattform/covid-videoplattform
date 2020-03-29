resource "google_compute_address" "bastion_ip_address" {
  name = "bastion-ip-address"
}

resource "google_compute_instance" "bastion" {
  name         = "bastion"
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
      nat_ip = google_compute_address.bastion_ip_address.address
    }
  }

  allow_stopping_for_update = true

  service_account {
    scopes = [
      "compute-rw",
      "storage-full",
      "cloud-platform",
    ]
  }

  #lifecycle {
  #  ignore_changes = [
  #    machine_type
  #  ]
  #}
}

locals {
  bastion_ansible_inventory = {
    hosts = {
      bastion = {
        internal_ip = google_compute_instance.bastion.network_interface[0].network_ip
        external_ip = google_compute_instance.bastion.network_interface[0].access_config[0].nat_ip
      }
    }
  }
}
