#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Please run as root."
  exit 1
fi

rm -f /etc/motd

apt update
apt upgrade -y
apt install -y curl tmux btop htop fastfetch
cat > /etc/profile.d/fastfetch.sh <<'EOF'
if [[ $- == *i* ]]; then
  fastfetch
fi
EOF
chmod +x /etc/profile.d/fastfetch.sh
