# 1. Hostname abrufen
$Hostname = hostname

# 2. Aktive Netzwerkadapter abrufen (nur IPv4)
$NetworkConfigs = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

Write-Host "=== NETZWERK-INFORMATIONEN ===" -ForegroundColor Cyan
Write-Host "Hostname: $Hostname" -ForegroundColor Yellow
Write-Host "----------------------------------"

foreach ($Config in $NetworkConfigs) {
    # IPv4-Adresse und Subnetzmaske filtern
    $IPAddress = ($Config.IPAddress | Where-Object { $_ -like '*.*' }) -join ', '
    $Subnet    = ($Config.IPSubnet  | Where-Object { $_ -like '*.*' }) -join ', '
    $Gateway   = $Config.DefaultIPGateway -join ', '
    $DNSServer = $Config.DNSServerSearchOrder -join ', '
    $DHCP      = if ($Config.DHCPEnabled) { "Ja" } else { "Nein" }

    # Ausgabe für jeden aktiven Adapter
    Write-Host "Adapter:     $($Config.Description)" -ForegroundColor Green
    Write-Host "IP-Adresse:  $IPAddress"
    Write-Host "Subnetzmaske:$Subnet"
    Write-Host "Gateway:     $Gateway"
    Write-Host "DNS-Server:  $DNSServer"
    Write-Host "DHCP aktiv:  $DHCP"
    Write-Host "----------------------------------"
}
