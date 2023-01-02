#!/usr/bin/env bash

function main() {
  local -r base_directory="$1"

  pushd "$base_directory" || exit 1

    # Initialize Terraform and upgrade provider/module references
    terragrunt run-all init -upgrade \
      --terragrunt-non-interactive \
      --terragrunt-source-update \
      --terragrunt-include-external-dependencies \
      --terragrunt-working-dir "$base_directory"

    # Apply all
    terragrunt run-all apply \
      --terragrunt-non-interactive \
      --terragrunt-source-update \
      --terragrunt-include-external-dependencies \
      --terragrunt-working-dir "$base_directory"

  popd || exit 1
}

main "$@"
