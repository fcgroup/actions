#!/usr/bin/env bash

function main() {
  local -r tfrc_path="$HOME/.terraform.d"

  # Create the containing directory tree
  mkdir -p "$tfrc_path"

  local -r tfrc_file_path="$tfrc_path/credentials.tfrc.json"

  # Save access token to credentials file
  echo '{}' | jq ".credentials[\"app.terraform.io\"].token |= \"$TFC_ACCESS_TOKEN\"" > "$tfrc_file_path"

  chmod 600 "$tfrc_file_path"

  echo "Terraform Cloud credentials file saved to $tfrc_file_path"
  ls -la "$tfrc_file_path"

  terraform login -help
}

main "$@"
