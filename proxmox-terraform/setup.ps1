# Setup script for Proxmox Terraform deployment
Write-Host "=== Proxmox Terraform Setup ===" -ForegroundColor Cyan

# Copy example tfvars
if (-not (Test-Path ".\terraform.tfvars")) {
    Copy-Item ".\terraform.tfvars.example" ".\terraform.tfvars"
    Write-Host "[!] Copied terraform.tfvars.example to terraform.tfvars" -ForegroundColor Yellow
    Write-Host "[!] Edit terraform.tfvars with your Proxmox details before running terraform apply" -ForegroundColor Yellow
}

# Check if Terraform is installed
if (-not (Get-Command "terraform" -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Terraform not found. Install from https://developer.hashicorp.com/terraform/install" -ForegroundColor Red
} else {
    Write-Host "[+] Terraform found: $(terraform --version)" -ForegroundColor Green
}

# Initialize Terraform
terraform init

Write-Host "=== Ready ===" -ForegroundColor Cyan
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Edit terraform.tfvars with your Proxmox credentials" -ForegroundColor White
Write-Host "  2. Run: terraform plan" -ForegroundColor White
Write-Host "  3. Run: terraform apply" -ForegroundColor White
