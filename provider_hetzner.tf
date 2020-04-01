# Provider Setup

variable "hetzner_token" {
  type        = string
  description = "Hetzner Cloud API-Token"
}

variable "hetzner_default_location" {
  type        = string
  default = "nbg1"
}

variable "hetzner_server_image" {
  type        = string
  default = "debian-10"
}

variable "hetzner_default_server_type" {
  type        = string
  default = "cx11"
}

variable "hetzner_ssh_keys_filenames" {
  type        = set(string)
  default = [
    ".ssh/buildbot.pub",
    ".ssh/brian.pub",
    ".ssh/florian.pub",
    ".ssh/markus.pub",
  ]
}

provider "hcloud" {
  token = var.hetzner_token
}


# Network

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


# VMs

resource "hcloud_ssh_key" "ssh_keys" {
  name = each.value
  public_key = file(each.value)
  for_each = var.hetzner_ssh_keys_filenames
}

locals {
  hetzner_vm_hosts = {
    for hostname, host in var.vm_hosts: hostname => host
    if host.provider == "hetzner"
  }
  hetzner_vm_hosts_with_groups = {
    for hostname, host in local.hetzner_vm_hosts: hostname => host if contains(keys(host),"groups")
  }
  hetzner_vm_hosts_without_groups = {
    for hostname, host in local.hetzner_vm_hosts: hostname => host if !contains(keys(host),"groups")
  }
}

resource "hcloud_server" "vms" {
  name = each.key
  image = var.hetzner_server_image
  server_type = var.hetzner_default_server_type
  location = var.hetzner_default_location
  ssh_keys = [for value in hcloud_ssh_key.ssh_keys: value.id]

  lifecycle {
    ignore_changes = [
      ssh_keys,
    ]
  }

  for_each = local.hetzner_vm_hosts
}

resource "hcloud_server_network" "vms" {
  server_id = hcloud_server.vms[each.key].id
  network_id = hcloud_network.internal_network.id

  for_each = local.hetzner_vm_hosts
}

locals {
  provider_hetzner = {
    hostvars = {
      for hostname, host in var.vm_hosts: hostname =>
        {
          #external_ip = hcloud_server.vms[hostname].ipv4_address
          #internal_ip = hcloud_server_network.vms[hostname].ip
        }
      if host.provider == "hetzner"
    }
  }
}
