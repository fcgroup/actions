#!/usr/bin/env bash

function main() {
  local -r target_url="$1"
  local -r target_hash="$2"
  local -r origin_url="$(git remote get-url origin | sed 's|.*:||' | sed 's|.git$||')"

  if [[ "$target_url" == "$origin_url" ]]; then
    local -r branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
    git fetch --all
    git checkout "$branch"
    git pull origin "$branch"
    git checkout "$target_hash"
  else
    echo "::debug::Evaluated $PWD but remote $origin_url does not match."
  fi
}

main "$@"
