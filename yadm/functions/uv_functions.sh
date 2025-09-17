#!/bin/bash

uv-list() {
  if [ -z "$1" ]; then
    echo -e "\033[1;31mUSAGE: uv-list <PACKAGE>\033[0m"
    return 1
  fi

  local pkg="$1"
  echo -e "\n\033[1;34m----- PACKAGES NEEDING '$pkg' -----\033[0m\n"
  uv tree --invert --package "$pkg" || echo "No packages depend on '$pkg'."

  echo -e "\n\n\033[1;32m----- '$pkg' DEPENDENCIES -----\033[0m\n"
  uv tree --package "$pkg" || echo "No dependencies found for '$pkg'."
  echo -e "\n\n"
}