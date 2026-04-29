#!/usr/bin/env bash

function main() {
  echo "$IMPORT_GPG_KEY" | gpg --batch --yes --no-tty --always-trust --import
  echo "ENCRYPTION_TEST" | gpg --always-trust --encrypt --recipient "$IMPORT_GPG_KEY_SUBJECT" > "temp.encrypted"
  gpg --batch --yes --no-tty --decrypt --passphrase "$IMPORT_GPG_KEY_PASSPHRASE" --pinentry-mode loopback --always-trust "temp.encrypted"
  rm -f "temp.encrypted";

  if [[ "$SET_GIT_GPG_CONFIG" == "true" ]]; then
    git config --global user.signingkey "$IMPORT_GPG_KEY_ID"
    git config --global commit.gpgsign true
  fi
}

main "$@"
