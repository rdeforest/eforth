# Reconnect or spin up new agent

set -e

source "${FSH:=~/.fsh}/lib/utils.sh"

# detect usable agent

agent_ok () {
  quiet timeout -k 5 3 ssh-add -l
}

sock=$( (set; getConfig ssh-agent localAgent) | grep ^SSH_AUTH_SOCK= | sed 's/^[^=]*=//')
for f in $sock /tmp/ssh*/agent*; do
  export SSH_AUTH_SOCK=$f

  if agent_ok; then
    return
  fi
done

if getConfig ssh-agent startIfMissing; then
  source <(ssh-agent)
fi
