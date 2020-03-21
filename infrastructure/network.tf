
resource "google_compute_network" "videoplattform_network" {
  name                    = "videoplattform-network"
  auto_create_subnetworks = "true"
}

data "google_compute_subnetwork" "videoplattform_subnetwork" {
  name   = "videoplattform-network"
}

resource "google_compute_firewall" "allow" {
  name    = "allow"
  network = google_compute_network.videoplattform_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "1000-2000","22"]
  }
}
