#!/usr/bin/env bash

function main() {
  local -r base_directory="$1"

  # Install the required version of Terraform (if not already installed)
  tfenv install

  # Import environment file if it exists
  if test -f ".env"; then
    # shellcheck disable=SC1091
    source "./.env"
  fi

  # Initialize Terraform and upgrade provider/module references
  terragrunt run init \
    --all \
    --non-interactive \
    --source-update \
    --queue-include-external \
    --working-dir "$base_directory" \
    -- -upgrade

  # Apply all
  terragrunt run apply \
    --all \
    --non-interactive \
    --queue-include-external \
    --working-dir "$base_directory"
}

main "$@"
