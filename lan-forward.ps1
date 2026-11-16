# Re-points the LAN address at Rakazo after a reboot.
# Run as Administrator: right-click → 使用 PowerShell 运行，或在管理员终端里：
#   powershell -ExecutionPolicy Bypass -File E:\projecte\rakazo\lan-forward.ps1
#
# WSL gets a new address when it restarts, so the port forwarding below has to follow it.
# Rakazo itself is bound to 0.0.0.0:5173 inside WSL; Windows only relays that to the LAN.

$ErrorActionPreference = 'Stop'
$port = 5173

$ip = (& wsl -d Ubuntu -- hostname -I) -split '\s+' | Where-Object { $_ } | Select-Object -First 1
if (-not $ip) { throw 'WSL is not running: start it (wsl -d Ubuntu) and run this again.' }
Write-Host "WSL address: $ip"

netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$port 2>$null | Out-Null
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$port connectaddress=$ip connectport=$port
Write-Host "forwarding 0.0.0.0:$port -> ${ip}:$port"

if (-not (Get-NetFirewallRule -DisplayName "Rakazo $port" -ErrorAction SilentlyContinue)) {
  New-NetFirewallRule -DisplayName "Rakazo $port" -Direction Inbound -Action Allow -Protocol TCP `
    -LocalPort $port -Profile Any -RemoteAddress LocalSubnet | Out-Null
  Write-Host "firewall rule added (local subnet only)"
} else {
  Write-Host "firewall rule already present"
}

$lan = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like '192.168.*' } | Select-Object -First 1).IPAddress
Write-Host ""
Write-Host "Rakazo: http://${lan}:$port/"
