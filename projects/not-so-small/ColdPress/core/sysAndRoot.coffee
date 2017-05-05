# Depends on COP.addMethod setting up wrappers which define functions which
# setup the instance-specific environments.

module.exports = ({COP}) ->
  [$sys, $root] = [COP.lookupName('sys'), COP.lookupName('root')]

  COP.addMethod $root, 'toString', ->
    switch $this
      when $root then "$root"
      when $sys  then "$sys"
      else            "##{id.toString()}"

  COP.addMethod $sys, 'create', (parent) ->
    create parent

  COP.addMethod $sys, 'addMethod', (obj, name, code) ->
    addMethod obj, name, code




      
