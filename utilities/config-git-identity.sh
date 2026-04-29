#!/usr/bin/env bash

function main() {
  local -r committer_email="$1"
  local -r committer_name="$2"

  git config --global user.email "$committer_email"
  git config --global user.name "$committer_name"
}

main "$@"
