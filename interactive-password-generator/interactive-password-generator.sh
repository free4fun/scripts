#!/usr/bin/env bash
# Interactive Password Generator Script (100% fiable)
# Autor: Mauricio Sosa Giri

set -euo pipefail

prompt() {
  local varname="$1"
  local message="$2"
  local default="${3:-}"
  local input
  while true; do
    read -rp "$message" input
    if [[ -z "$input" && -n "$default" ]]; then
      input="$default"
    fi
    if [[ -n "$input" ]]; then
      printf -v "$varname" '%s' "$input"
      break
    fi
  done
}

prompt length "Password length (8-64) [default 12]: " 12
if ! [[ "$length" =~ ^[0-9]+$ ]] || ((length < 8)) || ((length > 64)); then
  echo "Invalid length. Must be a number between 8 and 64."
  exit 1
fi

echo "Select character set:"
echo "1) Letters and numbers only (A-Za-z0-9)"
echo "2) ASCII special characters (A-Za-z0-9 + !@#...)"
echo "3) All printable ASCII characters (no spaces/newlines)"
prompt charset "Enter option [1-3, default 2]: " 2

case "$charset" in
  1)
    chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    ;;
  2)
    chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}|;:,.<>?/~'
    ;;
  3)
    # Caracteres ASCII imprimibles del 33 al 126, excepto el espacio (32)
    chars=$(awk 'BEGIN{for(i=33;i<=126;i++) printf "%c",i}')
    ;;
  *)
    echo "Invalid option. Exiting."
    exit 1
    ;;
esac

prompt count "How many passwords do you want to generate? [default 1]: " 1
if ! [[ "$count" =~ ^[0-9]+$ ]] || ((count < 1)) || ((count > 100)); then
  echo "Invalid count. Must be a number between 1 and 100."
  exit 1
fi

echo
echo "Generated passwords:"
for ((n=1; n<=count; n++)); do
  password=""
  for ((i=0; i<length; i++)); do
    idx=$(od -An -N2 -i /dev/urandom | awk -v max=${#chars} '{print ($1 % max)}')
    password+="${chars:idx:1}"
  done
  echo "$password"
done
