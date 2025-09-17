#!/bin/bash

# Usage: ./check_web.sh <hostname_or_ip>
TARGET=$1

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <hostname_or_ip>"
  exit 1
fi

while true; do
  echo "[$(date)] Scanning $TARGET for port 80..."
  nmap -p 80 --open -oG - "$TARGET" | grep -q "/open/" 

  if [ $? -eq 0 ]; then
    echo "Port 80 is open. Testing with curl..."
    curl -I --max-time 5 "http://$TARGET" 2>/dev/null | head -n 1
  else
    echo "Port 80 is closed on $TARGET."
  fi

  echo "Waiting 5 seconds..."
  sleep 5
done
