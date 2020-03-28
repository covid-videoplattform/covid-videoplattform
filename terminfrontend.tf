resource "google_compute_address" "terminfrontend_ip_address" {
  name = "terminfrontend-ip-address"
}

resource "google_compute_instance" "terminfrontend" {
  name         = "terminfrontend"
  machine_type = "n1-standard-1"

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
      nat_ip = google_compute_address.terminfrontend_ip_address.address
    }
  }

  allow_stopping_for_update = true
}

resource "local_file" "terminfrontend-info" {
    content  = jsonencode({
      "terraform_vm": google_compute_instance.terminfrontend
    })
    filename = "host_vars/terminfrontend/terraform-info.json"
}
