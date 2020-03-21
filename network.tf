
resource "google_compute_network" "videoplattform_network" {
  name                    = "videoplattform-network"
  auto_create_subnetworks = "true"
}
