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

resource "hcloud_ssh_key" "ssh_keys" {
  name = each.value
  public_key = file(each.value)
  for_each = var.hetzner_ssh_keys_filenames
}
