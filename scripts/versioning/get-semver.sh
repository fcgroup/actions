#!/usr/bin/env bash

declare SEMVER_FILE_PATH=".semver"

function output_semver() {
  if [ -s "$SEMVER_FILE_PATH" ]; then
    semver=$(cat "$SEMVER_FILE_PATH")
    echo "semver=$semver"
    exit 0
  fi
}

function get_semver() {
  # https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions
  # -s file
  #    True if file exists and has a size greater than zero.
  if [ ! -s "$SEMVER_FILE_PATH" ]; then
    git --no-pager tag --points-at "$CURRENT_COMMIT_HASH" --sort=-refname | head -n1 | tee "$SEMVER_FILE_PATH" > /dev/null
  fi

  output_semver

  echo "semver could not be determined by semantic-release and there is not a git tag pointing at the current commit $CURRENT_COMMIT_HASH."
  exit 1
}

output_semver "$@"
get_semver "$@"
