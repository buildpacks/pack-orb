#!/usr/bin/env bash

create_buildpack_flags() {
  local flags=()
  IFS=';' read -ra entries <<<"$1"
  for entry in "${entries[@]}"; do
    flags+=("--buildpack \"${entry}\"")
  done

  echo "${flags[@]}"
}

create_env_var_flags() {
  local flags=()
  IFS=';' read -ra entries <<<"$1"
  for entry in "${entries[@]}"; do
    IFS='=' read -ra parts <<<"$entry"
    flags+=("--env ${parts[0]}=\"${parts[1]}\"")
  done

  echo "${flags[@]}"
}

create_path_flag() {
  if [ -n "$1" ]; then
    echo "--path \"$1\""
  fi
}

create_tag_flags() {
  local flags=()
  IFS=';' read -ra entries <<<"$1"
  for entry in "${entries[@]}"; do
    flags+=("--tag \"${entry}\"")
  done

  echo "${flags[@]}"
}

create_command() {
  for i in PARAM_BUILDER,builder PARAM_IMAGE_NAME,image-name; do
    KEY=${i%,*}
    VAL=${i#*,}

    if [[ -z "${!KEY}" ]]; then
      echo "param '${VAL}' is required!"
      exit 1
    fi
  done

  echo pack build \
    --no-color \
    --builder \"${PARAM_BUILDER}\" \
    $(create_path_flag "${PARAM_PATH}") \
    $(create_buildpack_flags "${PARAM_BUILDPACKS}") \
    $(create_env_var_flags "${PARAM_ENV_VARS}") \
    $(create_tag_flags "${PARAM_TAGS}") \
    \"${PARAM_IMAGE_NAME}\"
}

main() {
  eval $(create_command)
}

if [[ -n $(echo "$0" | sed 's/.*_test$//;s/.*_test\.sh$//') ]]; then
  main "$@"
fi
