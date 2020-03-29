#resource "google_compute_address" "prosody_ip_address" {
#  name = "prosody-ip-address"
#}

resource "google_compute_instance" "prosody" {
  name         = "prosody"
  machine_type = "g1-small"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  metadata = {
    ssh-keys = "root:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwdEkFBdQfY5YB6LR1l+copG7rZXlGLQyWWwhZdNkpW"
  }

  network_interface {
    network = google_compute_network.videoplattform_network.self_link
    #access_config {
    #  nat_ip = google_compute_address.prosody_ip_address.address
    #}
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
