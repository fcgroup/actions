#!/usr/bin/env bash

function main() {
  local -r tfrc_path="$HOME/.terraform.d"

  # Create the containing directory tree
  mkdir -p "$tfrc_path"

  # Save access token to credentials file
  echo '{}' | jq ".credentials[\"app.terraform.io\"].token |= \"$TFC_ACCESS_TOKEN\"" > "$tfrc_path/credentials.tfrc.json"
}

main "$@"
