#!/usr/bin/env bash

function main() {
  echo "$CI_BOT_GPG_KEY" | gpg --batch --yes --no-tty --always-trust --import
  echo "ENCRYPTION_TEST" | gpg --always-trust --encrypt --recipient "$CI_BOT_GPG_KEY_SUBJECT" > "temp.encrypted"
  gpg --batch --yes --no-tty --decrypt --passphrase "$CI_BOT_GPG_KEY_PASSPHRASE" --pinentry-mode loopback --always-trust "temp.encrypted"
  rm -f "temp.encrypted";
  git config --global user.signingkey "$CI_BOT_GPG_KEY_ID"
  git config --global commit.gpgsign true
}

main "$@"
