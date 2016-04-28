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

  "$FSH_LIB/config" get "$context" "$key" "{format: \"shell\"}"
}
