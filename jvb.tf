variable "videobridge_count" {
  description = "Number of videobridges"
  type        = number
  default     = 1
}

resource "google_compute_address" "jvb_ip_address" {
  name = "jvb-${count.index}"
  count = var.videobridge_count
}

resource "google_compute_instance" "jvb" {
  name         = "jvb-${count.index}"
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
    access_config {
      nat_ip = google_compute_address.jvb_ip_address[count.index].address
    }
  }

  allow_stopping_for_update = true

  count = var.videobridge_count
}

locals {
  jvb_ansible_inventory = {
    hosts = {
      for instance in google_compute_instance.jvb[*]:
        instance.name => {
        internal_ip = instance.network_interface[0].network_ip
        external_ip = instance.network_interface[0].access_config[0].nat_ip
      }
    }
  }
}
