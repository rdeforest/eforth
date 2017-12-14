{ toString } = require './shared'

class TypeError extends Error
  constructor: (instance, klass) ->
    actual =
      switch
        when instance in [null, undefined] then toString instance
        when 'object' isnt typeof instance then typeof instance
        else                                    instance.constructor.name
      
    super "Wrong type: wanted #{klass.name}, got #{actual}"

Object.assign exports,
  {TypeError}

