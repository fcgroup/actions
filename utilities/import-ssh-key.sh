#!/usr/bin/env bash

function import_key() {
  local -r destination_path="$HOME/.ssh/id_rsa"

  mkdir -p "$HOME/.ssh/"

  echo "$CI_BOT_SSH_KEY" > "$destination_path"
  chmod 700 "$destination_path"

  echo "SSH key successfully imported to $destination_path"
  ls -la "$destination_path"
}

function set_git_default() {
  cat > "$HOME/.ssh/config" << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
EOF

  chmod 600 "$HOME/.ssh/config"
}

function import_known_hosts() {
  ssh-keyscan -t rsa github.com >> "$HOME/.ssh/known_hosts"
}

function main() {
  import_key
  set_git_default
  import_known_hosts
}

main "$@"
