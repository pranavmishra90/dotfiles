# Update-WSLPortProxy.ps1
# Forward Windows host ports to current WSL2 IP

# This script requires running PowerShell as Administrator.
# Create a task in Windows Task Scheduler, in the "Task Scheduler Library" to run this file with the following settings:
# General:
#   - Name: WSL2_Port_Forwarding
#   - Run with highest privileges
#   - Configure for: Windows 10
#   - Hidden: checked
# Triggers: none
# Actions:
#   - Action: Start a program
#   - Program/script: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
#   - Add arguments: -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\pmish\yadm\scripts\powershell\Update-WSLPortProxy.ps1"
# Settings:
#   - Allow task to be run on demand: checked
#   - Run task as soon as possible after a scheduled start is missed: checked
#   - Stop the task if it runs longer than: 1 hour
#   - If the running task does not end when requested, force it to stop: checked
#   - Do not start a new instance

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
