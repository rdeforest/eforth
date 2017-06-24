String::reverse = -> @split('').reverse().join('')

OPEN = '('
CLOSE = ')'

tokenize = (s, consumer) ->
  while s
    result = [matched, prefix, close, open] =
      s.match /^([^()]*)(\))?(\()?/

    switch
      when prefix
        consumer prefix
        s = s[prefix.length..]

      when close
        consumer CLOSE
        s = s[1..]

      when open
        consumer OPEN
        s = s[1..]

      else
        throw 'wtf'

_ = (s) ->
  pending = [""]

  parser = (token) ->
    #console.log "TOKEN", token
    switch token
      when OPEN
        #console.log "down", pending
        pending.unshift ""

      when CLOSE
        s = pending.shift()
        pending[0] += s.reverse()
        #console.log "up", pending

      else
        pending[0] += token
        #console.log "text", pending

  tokenize s, parser

  return pending[0]

reverseParentheses = (s) -> _(s)

module.exports = reverseParentheses

tester = require './genericTester'

tests = [
  [["a(bc)de"], "acbde"]
  [["a(bc)(de)"], "acbed"]
  [["a(bc(de))"], "adecb"]
  [["a(b(cde)fg(hi)j)k"], "ajhigfcdebk"]
]

tester tests, module.exports


