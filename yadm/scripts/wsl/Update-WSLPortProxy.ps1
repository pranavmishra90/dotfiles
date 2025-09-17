# Update-WSLPortProxy.ps1
# Forward Windows host ports to current WSL2 IP (Streamlit + Docker Swarm)

# Ports to forward
$tcpPorts = @(8501, 7496, 7497)  # TCP ports (Streamlit + swarm)
$udpPorts = @(7946, 4789)        # UDP ports (swarm overlay network)

# Get current WSL2 IP
$wslIP = (wsl hostname -I).Trim().Split(" ")[0]

if (-not $wslIP) {
    Write-Host "Could not detect WSL2 IP. Is WSL running?"
    exit 1
}

Write-Host "WSL2 IP detected: $wslIP"

# Forward TCP ports
foreach ($port in $tcpPorts) {
    # Remove any existing proxy rules for this port
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0 | Out-Null

    # Add fresh proxy rule
    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIP

    Write-Host ("TCP Port {0} forwarded to {1}:{0}" -f $port, $wslIP)
}

# Forward UDP ports using firewall rules
foreach ($port in $udpPorts) {
    # Remove existing firewall rule (if any)
    netsh advfirewall firewall delete rule name=("WSL2 UDP Port {0}" -f $port) | Out-Null

    # Add firewall rule to allow inbound UDP
    netsh advfirewall firewall add rule name=("WSL2 UDP Port {0}" -f $port) dir=in action=allow protocol=UDP localport=$port

    Write-Host ("UDP Port {0} allowed through firewall" -f $port)
}

Write-Host "WSL2 port forwarding updated successfully!"
