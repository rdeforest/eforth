# Combine data in various ways...

class Assembler
  constructor: ->

  collect: ->
    new Promise.reject new Error 'Virtual method "collect" not implemented'

  disburse: (data) ->
    new Promise.reject new Error 'Virtual method "disburse" not implemented'

class Concat extends Assembler
  constructor: (@children = []) ->
  
  collect: ->
    Promise.all child.collect for child in @children
      .then (parts) -> parts.reduce (a, b) -> a + b
