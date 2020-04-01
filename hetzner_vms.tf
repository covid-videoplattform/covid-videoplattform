variable "vm_hosts" {
  default = {
    bastion = { groups = [ "bastion_servers" , "monitoring" ] }
    reverse-proxy = { groups = [ "reverse_proxies" ] }
    terminfrontend = { groups = [ "terminfrontend_servers", "postgresql_servers"  ] }
    jitsi-single = { groups = [ "jitsi_prosody_servers", "jicofo_servers", "jitsi_webservers", "jitsi_videobridges" ] }
  }
}

locals {
  vm_hosts_with_groups = {
    for hostname, host in var.vm_hosts: hostname => host if contains(keys(host),"groups")
  }
  vm_hosts_without_groups = {
    for hostname, host in var.vm_hosts: hostname => host if !contains(keys(host),"groups")
  }
  vm_groups = distinct(flatten(values(local.vm_hosts_with_groups)[*].groups))
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

  for_each = var.vm_hosts
}

resource "hcloud_server_network" "vms" {
  server_id = hcloud_server.vms[each.key].id
  network_id = hcloud_network.internal_network.id

  for_each = var.vm_hosts
}

output "ansible_inventory" {
  value = {
    all = {
      hosts = {
        for hostname,hostvars in var.vm_hosts: hostname => {
          external_ip = hcloud_server.vms[hostname].ipv4_address
          internal_ip = hcloud_server_network.vms[hostname].ip
        }
      }
      children = {
        for group in local.vm_groups: group => {
          hosts = {
            for hostname, host in local.vm_hosts_with_groups:
              hostname => {}
              if contains(host.groups,group)
          }
        }
      }
    }
  }
}
