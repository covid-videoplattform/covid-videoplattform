resource "google_compute_address" "bastion_ip_address" {
  name = "bastion-ip-address"
}


resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network = google_compute_network.videoplattform_network.self_link
    access_config {
      nat_ip = google_compute_address.bastion_ip_address.address
    }
  }
}

resource "local_file" "bastion-info" {
    content  = jsonencode({
      "terraform_vm": google_compute_instance.bastion
    })
    filename = "host_vars/bastion/terraform-info.json"
}
