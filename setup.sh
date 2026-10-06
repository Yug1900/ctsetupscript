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
  read -r -p "Delete it? [Y/n] " delete_lxc_details
  case "${delete_lxc_details:-Y}" in
    [Nn]*) ;;
    *) rm -f /etc/profile.d/00_lxc-details.sh ;;
  esac
fi

cat > /etc/profile.d/fastfetch.sh <<'EOF'
if [[ $- == *i* ]]; then
  fastfetch
fi
EOF
chmod +x /etc/profile.d/fastfetch.sh
