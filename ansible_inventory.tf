locals {
  ansible_inventory_groups = {
    terminfrontend_servers = local.terminfrontend_ansible_inventory
    bastion_servers = local.bastion_ansible_inventory
    monitoring_servers = local.monitoring_ansible_inventory
    reverse_proxies = local.reverse_proxy_ansible_inventory
    frontend_servers = local.frontend_ansible_inventory
    terminfrontend_servers = local.terminfrontend_ansible_inventory
    jicofo_servers = local.jicofo_ansible_inventory
    prosody_servers = local.prosody_ansible_inventory
    videobridges = local.jvb_ansible_inventory
    turn_servers = turn_servers_ansible_inventory
  }
}
output "ansible_inventory" {
  value = {
    all = {
      hosts = {}
      children = local.ansible_inventory_groups
    }
  }
}
