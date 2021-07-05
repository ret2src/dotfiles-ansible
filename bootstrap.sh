#!/usr/bin/env sh

# Installs Ansible, runs playbook, configures all the things.
#
# Supported distributions:
# - Ubuntu 20.04
#
# Usage:
#   via curl:
#     $ sh -c "$(curl -fsSL https://raw.githubusercontent.com/ret2src/dotfiles/main/bootstrap.sh)"
#   via wget:
#     $ sh -c "$(wget -qO- https://raw.githubusercontent.com/ret2src/dotfiles/main/bootstrap.sh)"
#

set -e

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

distribution_is() {
  grep -Fiq "$@" /etc/*-release
}

print_info() {
  printf '%s[*]%s %s\n' "$BOLD$BLUE" "$RESET" "$*"
}

print_success() {
  printf '%s[+]%s %s\n' "$BOLD$GREEN" "$RESET" "$*"
}

print_warn() {
  printf '%s[!]%s %s\n' "$BOLD$YELLOW" "$RESET" "$*"
}

print_error() {
  printf '%s[-] ERROR: %s %s\n' "$BOLD$RED" "$*" "$RESET" >&2
}

setup_colors() {
  # Only use colors if connected to a terminal.
  if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    BOLD=''
    RESET=''
  fi
}

check_distro() {
  if distribution_is 'Ubuntu'; then
    print_info 'Detected distribution: Ubuntu'
  else
    print_error 'Your distribution is currently not supported.'
    exit 1
  fi
}

install_ansible() {
  if ! command_exists 'ansible'; then
    print_info 'Installing Ansible ...'
    if sudo apt-get install -y ansible > /dev/null; then
      print_success 'Successfully installed Ansible!'
    else
      print_error 'Installation of Ansible failed. Aborting.'
      exit 1
    fi
  else
    print_warn 'Ansible is already installed. Skipping installation.'
  fi
}

handover_to_ansible() {
  URL='https://github.com/ret2src/dotfiles'
  CHECKOUT='main'
  print_info "Pulling $URL @ $CHECKOUT ..."
  ansible-pull --ask-become-pass -C "$CHECKOUT" -U "$URL"
  unset URL
  unset CHECKOUT
}

main() {
  # Initialize support for colors and other formatting.
  setup_colors

  # Check if distribution is supported.
  check_distro

  # Install Ansible if it isn't already.
  install_ansible

  # Pull the repository and run the 'local.yml' playbook.
  handover_to_ansible
}

main "$@"
