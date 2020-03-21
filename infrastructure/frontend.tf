resource "google_compute_instance" "frontend" {
  name         = "frontend"
  machine_type = "f1-micro"

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
  }
}

resource "local_file" "frontend-info" {
    content  = jsonencode({
      "terraform_vm": google_compute_instance.frontend
    })
    filename = "host_vars/frontend/terraform-info.json"
}
