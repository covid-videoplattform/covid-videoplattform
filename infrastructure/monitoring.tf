resource "google_compute_address" "monitoring_ip_address" {
  name = "monitoring-ip-address"
}


resource "google_compute_instance" "monitoring" {
  name         = "monitoring"
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
    access_config {
      nat_ip = google_compute_address.monitoring_ip_address.address
    }
  }
}

resource "local_file" "monitoring-info" {
    content  = jsonencode({
      "terraform_vm": google_compute_instance.monitoring
    })
    filename = "host_vars/monitoring/terraform-info.json"
}
