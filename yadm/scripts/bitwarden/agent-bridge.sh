#!/usr/bin/env bash

NPIPERELAY="/mnt/c/Users/pmish/AppData/Local/Microsoft/WinGet/Packages/albertony.npiperelay_Microsoft.Winget.Source_8wekyb3d8bbwe/npiperelay.exe"

# already running
if ss -xl | grep -q "$SSH_AUTH_SOCK"; then
    return 0 2>/dev/null || exit 0
fi

# clean stale socket
rm -f "$SSH_AUTH_SOCK"

# start bridge
nohup socat \
  UNIX-LISTEN:"$SSH_AUTH_SOCK",fork \
  EXEC:"$NPIPERELAY -ei -s //./pipe/openssh-ssh-agent" \
  >/dev/null 2>&1 &
