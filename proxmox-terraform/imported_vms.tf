# Imported existing VMs from Proxmox node "prox"
# Import: terraform import proxmox_virtual_environment_vm.<name> prox/<vmid>

resource "proxmox_virtual_environment_vm" "existing_kali" {
  node_name = "prox"
  vm_id     = 100
  name      = "kali"

  cpu {
    cores   = 5
    sockets = 2
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 6496
  }

  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"
  boot_order    = ["scsi0", "net0"]

  disk {
    interface    = "scsi0"
    datastore_id = "data"
    size         = 80
    iothread     = true
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      disk, network_device, initialization, tags, keyboard_layout,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "existing_fedora43" {
  node_name = "prox"
  vm_id     = 101
  name      = "Fedora43"

  cpu {
    cores   = 10
    sockets = 2
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 5120
  }

  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"
  boot_order    = ["scsi0", "ide2", "net0"]

  disk {
    interface    = "scsi0"
    datastore_id = "data"
    size         = 100
    iothread     = true
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      disk, network_device, initialization, tags, keyboard_layout,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "existing_parrot" {
  node_name = "prox"
  vm_id     = 102
  name      = "Parrot"

  cpu {
    cores   = 4
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 5024
  }

  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"
  boot_order    = ["scsi0", "ide2", "net0"]

  disk {
    interface    = "scsi0"
    datastore_id = "data"
    size         = 32
    iothread     = true
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      disk, network_device, initialization, tags, keyboard_layout,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "existing_ubuntudesktop" {
  node_name = "prox"
  vm_id     = 104
  name      = "UbuntuDesktop"

  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096
  }

  scsi_hardware = "virtio-scsi-single"
  bios          = "seabios"
  boot_order    = ["scsi0", "net0"]

  disk {
    interface    = "scsi0"
    datastore_id = "data"
    size         = 250
    iothread     = true
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
  }

  vga {
    type   = "std"
    memory = 100
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      disk, network_device, initialization, tags, keyboard_layout,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "existing_homeassist" {
  node_name = "prox"
  vm_id     = 105
  name      = "HomeAssist"

  cpu {
    cores   = 2
    sockets = 2
    type    = "host"
  }

  memory {
    dedicated = 4092
  }

  scsi_hardware  = "virtio-scsi-single"
  bios           = "ovmf"
  boot_order     = ["sata0"]
  keyboard_layout = "en-us"
  tags           = []

  disk {
    interface    = "sata0"
    datastore_id = "local-lvm"
    size         = 32
    ssd          = true
  }

  network_device {
    bridge   = "vmbr0"
    firewall = true
  }

  operating_system {
    type = "l26"
  }

  lifecycle {
    ignore_changes = [
      disk, network_device, initialization,
    ]
  }
}
