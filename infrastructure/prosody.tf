resource "google_compute_address" "prosody_ip_address" {
  name = "prosody-ip-address"
}


resource "google_compute_instance" "prosody" {
  name         = "prosody"
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
      nat_ip = google_compute_address.prosody_ip_address.address
    }
  }
}

resource "local_file" "prosody-info" {
    content  = jsonencode({
      "terraform_vm": openstack_compute_instance_v2.prosody
    })
    filename = "{{playbook_dir}}/host_vars/prosody/terraform-info.json"
}
