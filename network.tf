resource "hcloud_network" "internal_network" {
  name = "internal_network"
  ip_range = "10.0.0.0/8"
}
resource "hcloud_network_subnet" "internal_network" {
  network_id = hcloud_network.internal_network.id
  type = "server"
  network_zone = "eu-central"
  ip_range   = "10.9.0.0/16"
}
