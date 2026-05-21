# Proxmox Provider
variable "pm_api_url" {
  description = "Proxmox API endpoint (e.g. https://192.168.0.8:8006)"
  type        = string

  validation {
    condition     = can(regex("^https?://", var.pm_api_url))
    error_message = "Must be a valid URL."
  }
}

variable "pm_user" {
  description = "Proxmox username (e.g. root@pam)"
  type        = string

  validation {
    condition     = length(var.pm_user) > 0
    error_message = "Username cannot be empty."
  }
}

variable "pm_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.pm_password) > 0
    error_message = "Password cannot be empty."
  }
}

variable "pm_tls_insecure" {
  description = "Skip TLS verification (true for self-signed certs)"
  type        = bool
  default     = true
}

# VM Configuration
variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for VM hostnames"
  type        = string
  default     = "vm"
}

variable "target_node" {
  description = "Proxmox node to deploy on"
  type        = string

  validation {
    condition     = length(var.target_node) > 0
    error_message = "Target node cannot be empty."
  }
}

variable "template_id" {
  description = "VM ID of the template to clone from (e.g. 10000)"
  type        = number
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "vm_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "vm_memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 32
}

variable "vm_storage" {
  description = "Storage pool for the VM disk"
  type        = string
  default     = "local-lvm"
}

variable "vm_network_bridge" {
  description = "Network bridge to attach (e.g. vmbr0)"
  type        = string
  default     = "vmbr0"
}

# Cloud-init
variable "vm_ipconfig_default" {
  description = "IP config: 'dhcp' or '10.0.0.100/24'"
  type        = string
  default     = "dhcp"
}

variable "vm_ci_user" {
  description = "Cloud-init default user"
  type        = string
  default     = "ubuntu"
}

variable "vm_ci_password" {
  description = "Cloud-init password"
  type        = string
  sensitive   = true
}

variable "vm_ssh_keys" {
  description = "List of SSH public keys for cloud-init"
  type        = list(string)
  default     = []
}

variable "vm_searchdomain" {
  description = "DNS search domain"
  type        = string
  default     = ""
}

variable "vm_nameserver_list" {
  description = "List of DNS nameservers"
  type        = list(string)
  default     = []
}
