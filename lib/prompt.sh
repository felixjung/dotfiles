#!/usr/local/env bash

lib_dir="$(dirname "$(realpath "$0")")"
source "$lib_dir/../lib/log.sh"

yes_no_prompt () {
  local result
  while true; do
    user "$1 [Y/n]: "
    read -rn 1 input

    if [[ $input = Y ]]; then
      echo ""
      result=0
      break
    elif [[ $input = n ]]; then
      echo ""
      result=1
      break
    else
      echo ""
      info "Invalid input ($input). Use Y or n."
      echo ""
    fi
  done

  return $result
}
