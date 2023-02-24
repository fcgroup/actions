#!/usr/bin/env bash

function create_config_file() {
  mkdir -p "$HOME/.config/"
  local -r destination_path="$HOME/.config/mark"

  echo "username = \"$CONFLUENCE_SERVICE_ACCOUNT\"" > "$destination_path"
  echo "password = \"$CONFLUENCE_API_TOKEN\"" >> "$destination_path"
  echo "base_url = \"$CONFLUENCE_URL\"" >> "$destination_path"
}

function process_files() {
  local -r file_pattern="$1"
  local -r error_path="$(mktemp)"
  local -r error_files="$(mktemp)"

  while read -r -d '' file; do

    # Skip base README.md
    if [[ "$file" == "./README.md" ]]; then
      echo "::debug::Skipping ./README.md"
      continue
    fi

    # Skip any files that are included in this repository (which is checked out to reference scripts like this one).
    if [[ "$file" == ./.actions/* ]]; then
      echo "::debug::Skipping $file"
      continue
    fi

    if ! grep -qP '<!--\s*Space:\s*\S+\s*-->' "$file"; then
      echo "::notice::Skipping $file missing metadata: Space"
      continue
    fi

    (
      echo "Syncing $file..."
      pushd "$(dirname "$file")" > /dev/null || exit
        filename="$(basename "$file")"
        mark -k --drop-h1 -f "$filename" 2> >(tee "$error_path")
        exit_status="$?"
        if [ $exit_status -ne 0 ]; then
          cat "$error_path"
          if [[ $(cat "$error_path") != *"doesn't contain metadata"* ]]; then
            echo -e "::warning::Failed to process file: $file";
            echo "$file" | tee -a "$error_files"
          fi
        fi
      popd > /dev/null || exit
    )
  done < <(find . -type f -name "$file_pattern" -print0)
  if [ -s "$error_files" ]; then
    echo "::error::Failed to process files with mark: $(printf ', %s' "$(<"$error_files")" | cut -f2- -d,)"
    exit 1
  fi
}

function main() {
  create_config_file
  process_files "$@"
}

main "$@"
