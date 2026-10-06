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

if [[ -e /etc/profile.d/00_lxc-details.sh ]]; then
  echo "/etc/profile.d/00_lxc-details.sh is a leftover script from Proxmox Community scripts and is redundant with fastfetch."
  if [[ -t 0 ]]; then
    read -r -p "Delete it? [y/N] " delete_lxc_details
    case "${delete_lxc_details:-N}" in
      [Yy]|[Yy][Ee][Ss]) rm -f /etc/profile.d/00_lxc-details.sh ;;
    esac
  else
    echo "No interactive terminal is available, so leaving it in place."
  fi
fi

cat > /etc/profile.d/fastfetch.sh <<'EOF'
if [[ $- == *i* ]]; then
  fastfetch
fi
EOF
chmod +x /etc/profile.d/fastfetch.sh
