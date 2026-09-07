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

FASTFETCH_LINE='if [[ $- == *i* ]] && [[ "${EUID}" -ne 0 ]]; then fastfetch; fi'
if ! grep -Fxq "$FASTFETCH_LINE" /etc/profile; then
  echo "$FASTFETCH_LINE" >> /etc/profile
fi
