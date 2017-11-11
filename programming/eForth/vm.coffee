# Per section 1 of http://www.exemark.com/FORTH/eForthOverviewv5.pdf

extractFunctionDefinition = null

do ->
  # Keep scope minimal but only compile regexp once
  functionRegexp = ///
    ^ function \s*
    \( \s* ([^)])* \) \s*  # args
    { \s* (.*) }           # body
    ///

  extractFunctionDefinition = (fn) ->
    code    = fn.toString()
    matched = code.match functionRegexp

    unless matched
      throw new Error "code.toString() didn't match the function pattern. Value was:\n#{code}"

    [theWholeString, argStr, body] = matched

    argNames =
      argStr
        .split /\s*/
        .map (argName) -> argName.trim()

hasInit  = (klass) -> 'function' is typeof klass::init
callInit = (klass, self, definition, rest) -> klass::init.call @, definition, rest...

listToObject = (entries) -> Object.assign {}, entries...

class Primitive extends Function
  constructor: (def, rest...) ->
    unless 'object' is typeof def and Object.keys(def).length is 1
      throw 'definition must be a single-key object'

    ( for name, definition of def
        argNames = []
        body = ''

        if 'function' is typeof definition
          {argNames, body} = extractFunctionDefinition

        super argNames..., body

        klass = @constructor

        while klass isnt Primitive
          currentKlass = klass
          klass = klass.constructor
          currentKlass
    ) .reverse()
      .filter  hasInit
      .forEach (klass) -> callInit klass, @, definition, rest

    @constructor[@name] = @

readOnly = (obj, nameOrSymbol, value) ->
  Object.defineProperty obj, nameOrSymbol, get: -> value

readOnly Primative, Symbol.species, Function

class Macro    extends Primitive
  init: (definition, rest...) -> @ops  = [definition, rest...]

class Opcode   extends Primitive
  init: (definition, rest...) ->
    if definition
      @args = [definition, rest...]

class Register extends Primitive

Register IP: {}
Register WP: {}
Register SP: {}
Register RP: {}
Register UP: {}

Opcode LODSW: undefined
Opcode JMP: 'address'

Macro $NEXT: LODSW, Opcode.JMP Register.AX

class Memory extends Buffer
  constructor: (length = 0) ->
    @_ = Buffer.concat [Buffer.from ''], length

  extendTo: (addr) ->
    if addr >= @length
      @_ = Buffer.concat @_, addr + 1

    @

for width in [8, 16, 32]
  peek = Buffer::['readUInt' + width + 'BE']
  Memory::['peek' + width] = (addr) -> peek.call @memory, addr

  poke = Buffer::['writeUInt' + width + 'BE']
  Memory::['poke' + width] = (addr, value) ->
    unless 0 <= addr
      throw new Error 'Negative addresses not supported (yet?)'

    @extendTo addr

    poke.call @memory, addr, value

class VM
  constructor: ->
    @memory = new Memory

    @registers = listToObject (
      Object
        .keys Register.instances
        .map (name) -> "#{name.toLowerCase()}": 0
      )

  op:    Opcode.instances
  macro: Macro .instances

Object.assign module.exports, {VM}
