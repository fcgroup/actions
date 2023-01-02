#!/usr/bin/env bash

function main() {
  local -r latest_version="$(git describe --tags --abbrev=0)"
  echo "Latest tag version: $latest_version"

  local -r previous_hash="$(git rev-list --tags --skip=1 --max-count=1)"
  local -r previous_version="$(git describe --abbrev=0 --tags "$previous_hash")"

  echo "Previous tag version was: $previous_version"

  # Replace the dot with blank space for the version
  local -r current=${latest_version//./ }
  local -r previous=${previous_version//./ }

  # Extract major, minor and patch from current version
  local -r current_patch=$(echo "$current" | awk '{print $3}')
  local -r current_minor=$(echo "$current" | awk '{print $2}')
  local -r current_major=$(echo "$current" | awk '{print $1}')

  # Extract major, minor and patch from previous version
  local -r previous_patch=$(echo "$previous" | awk '{print $3}')
  local -r previous_minor=$(echo "$previous" | awk '{print $2}')
  local -r previous_major=$(echo "$previous" | awk '{print $1}')

  # Compare the version
  if [ "$current_major" -gt "$previous_major" ]; then
    echo "Major version was updated"
    echo "semver_diff=major"
  elif [ "$current_minor" -gt "$previous_minor" ]; then
    echo "Minor version was updated"
    echo "semver_diff=minor"
  elif [ "$current_patch" -gt "$previous_patch" ]; then
    echo "Patch version was updated"
    echo "semver_diff=patch"
  else
    echo "No change in version"
    echo "semver_diff=none"
  fi
}

main "$@"
