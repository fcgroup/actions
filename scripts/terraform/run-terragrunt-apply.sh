#!/usr/bin/env bash

function main() {
  local -r base_directory="$1"

  # Run a full encrypt/decrypt lifecycle to prevent sops from prompting for GPG key passphrase
  echo "ENCRYPTION_TEST" | gpg --always-trust --encrypt --recipient "$CI_BOT_GPG_KEY_SUBJECT" > "temp.encrypted"
  gpg --batch --yes --no-tty --decrypt --passphrase "$CI_BOT_GPG_KEY_PASSPHRASE" --pinentry-mode loopback --always-trust "temp.encrypted"
  rm -f "temp.encrypted";

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
}

main "$@"
