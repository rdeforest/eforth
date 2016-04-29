debug () {
  level=$1; shift

  if [ "$level" -lt "$CONFIG_DEBUG" ]; then
    echo "DEBUG: " "$@"
  fi
}

warn () {
  echo "$@" >2
}

error () {
  code=$1; shift
  warn "$@"
  exit $code
}

quiet () {
  "$@" > /dev/null 2>&1
}

fsh_config_get () {
  context="$1"
  key="$2"

  # Don't try this on your dad's stereo.
  # Only under hip-hop supervision, yeah.
  source <("$FSH_LIB/config" shell_dump)
}
