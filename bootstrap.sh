#!/usr/bin/env sh
#
# ┌────────────────────────────────────────────────────────────────────────┐
# │░░░█▀█░█▀█░█▀▀░▀█▀░█▀▄░█░░░█▀▀░░░█▀▄░█▀█░█▀█░▀█▀░█▀▀░▀█▀░█▀▄░█▀█░█▀█░░░░│
# │░░░█▀█░█░█░▀▀█░░█░░█▀▄░█░░░█▀▀░░░█▀▄░█░█░█░█░░█░░▀▀█░░█░░█▀▄░█▀█░█▀▀░░░░│
# │░░░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░░░▀▀░░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀░▀░▀░▀░▀░░░░░░│
# └────────────────────────────────────────────────────────────────────────┘
#
# This script installs Ansible and leverages it to configure all the things.
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
  grep -Fq "$@" /etc/*-release
}

print_banner() {
  printf '%s\n\n' '┌────────────────────────────────────────────────────────────────────────┐
│░░░█▀█░█▀█░█▀▀░▀█▀░█▀▄░█░░░█▀▀░░░█▀▄░█▀█░█▀█░▀█▀░█▀▀░▀█▀░█▀▄░█▀█░█▀█░░░░│
│░░░█▀█░█░█░▀▀█░░█░░█▀▄░█░░░█▀▀░░░█▀▄░█░█░█░█░░█░░▀▀█░░█░░█▀▄░█▀█░█▀▀░░░░│
│░░░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░░░▀▀░░▀▀▀░▀▀▀░░▀░░▀▀▀░░▀░░▀░▀░▀░▀░▀░░░░░░│
└────────────────────────────────────────────────────────────────────────┘
                                                        by ret2src, 0x07E5'
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

print_question() {
  printf '%s[?]%s %s\n' "$BOLD" "$RESET" "$*"
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
    print_error 'Your distribution is not supported.'
    exit 1
  fi
}

install_ansible() {
  if ! command_exists 'ansible'; then
    print_info 'Ansible does not seem to be installed yet.'
    print_info 'Installing Ansible ...'
    if sudo apt-get install -y ansible > /dev/null; then
      print_success 'Successfully installed Ansible!'
    else
      print_error 'Ansible could not be installed. Aborting.'
      exit 1
    fi
  else
    print_warn 'Ansible is already installed. Skipping installation.'
  fi
}

print_available_options() {
  INDEX=0
  while [ -n "$*" ]; do
    printf '    [%s] %s\n' "$INDEX" "$1"
    shift
    INDEX=$((INDEX+1))
  done
  unset INDEX
}

set_desired_config() {
  shift $(($1+1))
  DESIRED_CONFIG="$1"
  print_info "Selected configuration: $DESIRED_CONFIG"
}

prompt_configuration_selection() {
  print_question "Please select the desired configuration:"
  printf '\n'
  print_available_options "$@"
  printf '\n'

  while true; do
    printf '    > '
    read -r SELECTION
    if [ "$SELECTION" -ge 0 ] && [ "$SELECTION" -lt "$#" ]; then
      set_desired_config "$SELECTION" "$@"
      break
    else
      print_error "Not a valid selection."
    fi
  done
  unset SELECTION
}

handover_to_ansible() {
  REPO='https://github.com/ret2src/dotfiles'
  print_info "Pulling $REPO ..."
  ansible-pull --ask-become-pass -e "desired_config=$DESIRED_CONFIG" -U "$REPO"
  unset REPO
}

main() {
  # Initialize support for colors and other formatting.
  setup_colors

  # Print information about the script.
  print_banner

  # Check if distribution is supported.
  check_distro

  # Install Ansible if it isn't already.
  install_ansible

  # Ask user what configuration to use.
  prompt_configuration_selection 'laptop'

  # Pull the repository and run the 'local.yml' playbook.
  handover_to_ansible
}

main "$@"
