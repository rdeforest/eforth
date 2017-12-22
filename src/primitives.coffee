{ Primitive, Macro, Opcode, Register
  ConstantNumber, DirectReference
  Code
} = require './primitive'

###

Register
  IP: null, SI: null
  SP: null
  BP: null
  WP: null, AX: null

Opcode
  HALT: (machine) -> machine.halt()

  ADD:  (machine, target, amount) ->
    {registers} = machine
    registers.put target, registers.get(target) + amount machine

  SUB:  (machine, target, amount) ->
    {registers} = machine
    registers.put target, registers.get(target) - amount machine

  LODSW: ({registers}, to, from) ->
    registers.copy to, from
    return

  JMP: ({registers}, from) ->
    registers.copy IP, from
    return

  XCHG: ({registers}, a, b) ->
    tmp =
    registers.get  a
    registers.copy a, b
    registers.put  b, tmp

  POP: ({registers}, dest) ->
    registers.copy dest, SP
    registers.put  SP, registers.get(SP) - 1

  PUSH: ({registers}, src) ->
    registers.put  SP, registers.get(SP) + 1
    registers.copy SP, src

###

module.exports = (machine) ->
  Macro
    $NEXT:  ->
      machine.jump machine.register.SW.value

  Code
    doList: ->
      machine.push machine.stack.return, machine.register.IP
      $NEXT machine

  Word
    exit:   XCHG    BP, SP
            POP     SI
            XCHG    BP, SP
            $NEXT

  Word
    bye:    HALT

  Word
    "?RX":  GETCHAR
            $NEXT

  Word
    "TX!":  PUTCHAR
            $NEXT

  Word
    "EXECUTE": POP BX
               JMP BX

  Word
    "doLIT": LODSW
             PUSH AX
             $NEXT

  Word
    next:   SUB 
    

# vim: sts=10
