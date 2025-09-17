#!/bin/bash

function dnode(){
	local input_command="$1"

	if [[ $input_command == 'labels' ]]; then
		docker node ls -q | xargs docker node inspect   -f '{{ .ID }} [{{ .Description.Hostname }}]: {{ range $k, $v := .Spec.Labels }}{{ $k }}={{ $v }} {{end}}'
	fi

	bash ~/yadm/scripts/docker-node-labels.sh
}

deploy_stack() {
  local compose_args=()
  local detach_flag="$STACK_DEPLOY_DETACHED_VALUE"

  local detach_flag_set=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --file|-f)
        shift
        compose_args+=("-c" "$1")
        ;;
      --detach)
        detach_flag="true"
        detach_flag_set=true
        ;;
      --no-detach)
        detach_flag="false"
        detach_flag_set=true
        ;;
      *)
        echo "Unknown argument: $1" >&2
        ;;
    esac
    shift
  done

  if ! $detach_flag_set; then
    set_detach_flag
    detach_flag="$STACK_DEPLOY_DETACHED_VALUE"
  fi

  set -a
  if [ -f ./.env ]; then
    . ./.env
  else
    echo "Warning: .env file not found, continuing without environment variables." >&2
  fi
  set +a
  docker stack deploy "${compose_args[@]}" --detach="$detach_flag" "$stack_name"
}

set_detach_flag() {
  if [ -z "${STACK_DEPLOY_DETACHED+x}" ]; then
    STACK_DEPLOY_DETACHED=true
    echo "STACK_DEPLOY_DETACHED not set. Defaulting to true."
  fi

  if [ -z "$1" ]; then
    read -t 3 -p "Set detach to true or false? (default: $STACK_DEPLOY_DETACHED, waiting 5s): " detach_input
    if [ -z "$detach_input" ]; then
      set -- "$STACK_DEPLOY_DETACHED"
    else
      set -- "$detach_input"
    fi
  fi
  export STACK_DEPLOY_DETACHED_VALUE="$1"
}
