resource "google_compute_instance" "prosody" {
  name         = "prosody"
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
  }

  allow_stopping_for_update = true
}

locals {
  prosody_ansible_inventory = {
    hosts = {
      prosody = {
        internal_ip = google_compute_instance.prosody.network_interface[0].network_ip
        #external_ip = google_compute_instance.prosody.network_interface[0].access_config[0].nat_ip
      }
    }
  }
}
