
resource "google_compute_network" "videoplattform_network" {
  name                    = "videoplattform-network"
  auto_create_subnetworks = "true"
}

data "google_compute_subnetwork" "videoplattform_subnetwork" {
  name   = "videoplattform-network"
}
