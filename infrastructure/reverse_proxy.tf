resource "google_compute_address" "reverse_proxy_ip_address" {
  name = "reverse-proxy-ip-address"
}


resource "google_compute_instance" "reverse_proxy" {
  name         = "reverse-proxy"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network = google_compute_network.videoplattform_network.self_link
    access_config {
      nat_ip = google_compute_address.reverse_proxy_ip_address.address
    }
  }
}

resource "local_file" "{{terraform_hostname}}-info" {
    content  = jsonencode({
      "terraform_vm": openstack_compute_instance_v2.{{terraform_hostname}}
    })
    filename = "{{playbook_dir}}/host_vars/{{inventory_hostname}}/terraform-info.json"
}
