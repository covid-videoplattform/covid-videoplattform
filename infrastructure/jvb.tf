variable "videobridge_count" {
  description = "Number of videobridges"
  type        = number
  default     = 3
}

resource "google_compute_address" "jvb_ip_address" {
  name = "jvb-${count.index}"
  count = var.videobridge_count
}

resource "google_compute_instance" "jvb" {
  name         = "jvb-${count.index}"
  machine_type = "e2-highcpu-4"

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

resource "local_file" "jvb-info" {
    content  = jsonencode({
      "terraform_vm": google_compute_instance.jvb[count.index]
    })
    filename = "host_vars/${google_compute_instance.jvb[count.index].name}/terraform-info.json"
    count = var.videobridge_count
}
