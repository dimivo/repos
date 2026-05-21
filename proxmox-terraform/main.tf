terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint = var.pm_api_url
  username = var.pm_user
  password = var.pm_password
  insecure = var.pm_tls_insecure
}

resource "proxmox_virtual_environment_vm" "vm" {
  count     = var.vm_count
  node_name = var.target_node
  name      = "${var.vm_name_prefix}-${count.index + 1}"

  clone {
    vm_id = var.template_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = var.vm_cores
    sockets = var.vm_sockets
  }

  memory {
    dedicated = var.vm_memory
  }

  disk {
    interface    = "scsi0"
    datastore_id = var.vm_storage
    size         = var.vm_disk_size
    iothread     = true
  }

  network_device {
    bridge = var.vm_network_bridge
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.vm_ipconfig_default
      }
    }

    user_account {
      username = var.vm_ci_user
      password = var.vm_ci_password
      keys     = var.vm_ssh_keys
    }

    dns {
      domain  = var.vm_searchdomain
      servers = var.vm_nameserver_list
    }
  }

  operating_system {
    type = "l26"
  }
}
