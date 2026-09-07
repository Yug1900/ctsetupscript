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

if ! grep -Fxq "fastfetch" /etc/profile; then
  echo "fastfetch" >> /etc/profile
fi
