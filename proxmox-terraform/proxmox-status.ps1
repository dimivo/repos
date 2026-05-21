param(
    [string]$ApiUrl,
    [string]$User,
    [string]$Password
)

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { param($sender, $cert, $chain, $errors) $true }
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

if (-not $ApiUrl) { $ApiUrl = Read-Host "Proxmox API URL (e.g. https://192.168.0.8:8006)" }
if ($ApiUrl -notmatch '/api2/json$') { $ApiUrl = $ApiUrl.TrimEnd('/') + '/api2/json' }
if (-not $User)   { $User   = Read-Host "Username (e.g. root@pam)" }
if (-not $Password) { $Password = Read-Host "Password" }

function Invoke-ProxmoxAPI($path, $method = "GET", $body = $null) {
    $req = [System.Net.HttpWebRequest]::Create("$ApiUrl$path")
    $req.Method = $method
    if ($body) { $req.ContentType = "application/x-www-form-urlencoded"; $bytes = [System.Text.Encoding]::UTF8.GetBytes($body); $req.ContentLength = $bytes.Length; $req.GetRequestStream().Write($bytes, 0, $bytes.Length) }
    if ($ticket) { $req.Headers.Add("Cookie", "PVEAuthCookie=$ticket") }
    $resp = $req.GetResponse()
    $reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
    $content = $reader.ReadToEnd()
    $reader.Close(); $resp.Close()
    return $content | ConvertFrom-Json
}

try {
    $auth = Invoke-ProxmoxAPI "/access/ticket" POST "username=$User&password=$Password"
    $ticket = $auth.data.ticket
    Write-Host "`nConnected!" -ForegroundColor Green

    $version = Invoke-ProxmoxAPI "/version"
    Write-Host "Proxmox VE $($version.data.version)`n" -ForegroundColor Cyan

    $nodes = Invoke-ProxmoxAPI "/nodes"
    foreach ($node in $nodes.data) {
        Write-Host "=== Node: $($node.node) ($($node.status)) ===" -ForegroundColor Yellow
        Write-Host "  CPU: $([math]::Round($node.cpu * 100, 1))%  |  Memory: $([math]::Round($node.mem / 1GB, 1))GB / $([math]::Round($node.maxmem / 1GB, 1))GB"

        $vms = Invoke-ProxmoxAPI "/nodes/$($node.node)/qemu"
        Write-Host "`n  VMs:" -ForegroundColor Cyan
        $vms.data | Sort-Object vmid | ForEach-Object {
            $statusColor = if ($_.status -eq "running") { "Green" } else { "Red" }
            $memGB = [math]::Round($_.mem / 1GB, 1)
            $maxMemGB = [math]::Round($_.maxmem / 1GB, 1)
            Write-Host "    [$($_.vmid)] $($_.name)" -NoNewline
            Write-Host "  $($_.status)" -ForegroundColor $statusColor -NoNewline
            Write-Host "  |  CPU: $($_.cpus)  |  Mem: ${memGB}G/$maxMemGB" -NoNewline
            if ($_.uptime -and $_.status -eq "running") {
                $up = [TimeSpan]::FromSeconds($_.uptime)
                Write-Host "  |  Up: $($up.Days)d $($up.Hours)h $($up.Minutes)m" -NoNewline
            }
            Write-Host ""
        }

        $storage = Invoke-ProxmoxAPI "/nodes/$($node.node)/storage"
        Write-Host "`n  Storage:" -ForegroundColor Cyan
        $storage.data | ForEach-Object {
            $contentStr = $_.content -join ","
            Write-Host "    $($_.storage)  [type=$($_.type)]  content=$contentStr"
        }

        Write-Host ""
    }

    Write-Host "=== Cluster Resources ===" -ForegroundColor Yellow
    $cluster = Invoke-ProxmoxAPI "/cluster/resources"
    Write-Host "  Total VMs: $(($cluster.data | Where-Object { $_.type -eq 'qemu' }).Count)" -ForegroundColor White

} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}
