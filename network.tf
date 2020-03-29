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
    protocol = "all"
  }
}
