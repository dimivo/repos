output "vm_ids" {
  description = "IDs of the created VMs"
  value       = proxmox_virtual_environment_vm.vm[*].vm_id
}

output "vm_names" {
  description = "Names of the created VMs"
  value       = proxmox_virtual_environment_vm.vm[*].name
}
