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

resource "google_compute_address" "nat-ip" {
  name = "nat-ip"
}

resource "google_compute_router" "router" {
    name    = "router"
    network = google_compute_network.videoplattform_network.self_link
    bgp {
        asn = 64514
    }
}

resource "google_compute_router_nat" "simple-nat" {
    name                               = "nat"
    router                             = google_compute_router.router.name
    nat_ip_allocate_option   = "MANUAL_ONLY"
    nat_ips                            = [google_compute_address.nat-ip.self_link]
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
