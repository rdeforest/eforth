# Once again with the meta thoughts
#
# What if I had a MOP class which used Symbols to hide info on objects?

cs = require 'coffeescript'

s = {}

for key in 'MOPPER source comment'.split ' '
  s[key] = Symbol key

class Mopper
  constructor: (@subject) ->
    @subject[s.MOPPER] = @

  addMethod: (name, args, block) ->
    if 'object' is typeof args
      args = ("#{k} = #{v}" for k, v of args)

    if Array.isArray args
      args = args.join ", "

    if 'string' is typeof args
      args = "(#{args}) "
    else
      args = ''

    compiled = cs.eval src = "#{args}->#{block}"
    @subject[name] = compiled
    compiled[s.source] = src

  getSource : (name) -> @subject[name]?[s.source]
  getComment: (name) ->
    ( if name
        if Object.hasOwnProperty @subject, name
          @subject[name]
      else
        @subject
    )?[s.comment]

  setComment: (comment) -> @subject[s.comment] = comment

MOP =
  moppify: (o) -> new Mopper o; o

  send: (o, messageAndArgs) ->
    for k, v of messageAndArg
      o[s.MOPPER][message] [].concat(args)...

# Usage

if false
  class Foo
    methodBar: (baz) -> "bumble"

  MOP.moppify Foo
  MOP.send Foo, setComment: 'hello'
  MOP.send Foo, addMethod: 'hello', (world: 'world'), """
      console.log "hello #{world}!"
    """

