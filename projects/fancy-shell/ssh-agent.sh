# Reconnect or spin up new agent

if [ -z "$FSH" -o ! -d "$FSH" ]; then
  echo "Fancy Shell not setup?"
  exit 1
fi

source "$FSH/lib/utils.sh"

# detect usable agent

agent_ok () {
  if [ -e "$sock" ]; then
    return quiet timeout -k 5 3 ssh-add -l
  else
    return 256
  fi
}

sock=$(set | grep ^SSH_AUTH_SOCK= | sed 's/^[^=]*=//')
for f in $sock /tmp/ssh*/agent*; do
  export SSH_AUTH_SOCK=$f

  if agent_ok; then
    return
  fi
done

# if allowed, spin up new agent
createAgent=$(config get ssh-agent startIfMissing)
