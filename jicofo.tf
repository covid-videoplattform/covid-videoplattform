#resource "google_compute_address" "jicofo_ip_address" {
#  name = "jicofo-ip-address"
#}

resource "google_compute_instance" "jicofo" {
  name         = "jicofo"
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
    #access_config {
    #  nat_ip = google_compute_address.jicofo_ip_address.address
    #}
  }

  allow_stopping_for_update = true
}

locals {
  jicofo_ansible_inventory = {
    hosts = {
      jicofo = {
        internal_ip = google_compute_instance.jicofo.network_interface[0].network_ip
        #external_ip = google_compute_instance.jicofo.network_interface[0].access_config[0].nat_ip
      }
    }
  }
}
