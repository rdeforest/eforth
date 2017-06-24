export FSH_CONF=${FSH_CONF:-$FSH/conf}
mkdir -p "$FSH_CONF/global"

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

getConfig () {
  context="$1"
  key="$2"

  ctxconf="$FSH_CONF/$context/$key"
  if [ -e "$ctxconf" ]; then
    cat "$ctxconf"
  else
    cat "$FSH_CONF/global/$key"
  fi
}

setConfig () {
  context="$1"
  key="$2"

  if [ -z "$key" ]; then
    key="$1"
    context=global
  fi

  cat > "$FSH_CONF/$context/$key"
}


