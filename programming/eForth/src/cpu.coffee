# abstract
#   To be overloaded:
#   constructor - invoke super() with specifics

module.exports = ->
  class CPU
    constructor: (definition) ->
      { registers
        opCodes
        memory
      } = definition

      klass      = @constructor

      @registers = klass.initRegisters @, registerNames
      @ops       = klass.initOpcodes   @, opCodes
      @memory    = klass.initMemory    @, memoryInfo

      @running   = 0

    step: ->
      setImmediate ->
        try
          (@memory.get @registers.ip).exec @
          @step()
        catch e
          @reportError e

    run: -> @step()

