param([switch]$DryRun)

$imports = @(
    @{ Name = "proxmox_virtual_environment_vm.existing_kali";         Id = "prox/100" },
    @{ Name = "proxmox_virtual_environment_vm.existing_fedora43";     Id = "prox/101" },
    @{ Name = "proxmox_virtual_environment_vm.existing_parrot";       Id = "prox/102" },
    @{ Name = "proxmox_virtual_environment_vm.existing_ubuntudesktop"; Id = "prox/104" },
    @{ Name = "proxmox_virtual_environment_vm.existing_homeassist";   Id = "prox/105" }
)

Write-Host "=== Proxmox VM Import Script ===" -ForegroundColor Cyan
Write-Host ""

foreach ($import in $imports) {
    $cmd = "terraform import $($import.Name) $($import.Id)"
    if ($DryRun) {
        Write-Host "[DRY-RUN] $cmd" -ForegroundColor Yellow
    } else {
        Write-Host "Importing $($import.Name) ($($import.Id))..." -ForegroundColor Green
        Invoke-Expression $cmd
        Write-Host ""
    }
}
