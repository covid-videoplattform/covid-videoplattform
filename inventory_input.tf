variable "vm_hosts" {
  default = {
    bastion = { provider = "hetzner", groups = [ "bastion_servers" , "monitoring" ] }
    reverse-proxy = { provider = "hetzner", groups = [ "reverse_proxies" ] }
    terminfrontend = { provider = "hetzner", groups = [ "terminfrontend_servers", "postgresql_servers"  ] }
    jitsi-single = { provider = "hetzner", groups = [ "jitsi_prosody_servers", "jicofo_servers", "jitsi_webservers", "jitsi_videobridges" ] }
    turn = { provider = "hetzner", groups = [ "turn_servers" ] }
  }
}

variable "groups" {
  default = {
    reverse_proxies = {
    }
  }
}
