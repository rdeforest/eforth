{ Primitive, Macro, Opcode, Register
  ConstantNumber, DirectReference
  Code
} = require './primitive'

Opcode
  LODSW: ({registers}, to, from) ->
    registers.copy to, from
    return

  JMP: ({registers}, from) ->
    registers.copy IP, from
    return

Macro
  $next:  LODSW
          JMP     AX

Code
  exit:   XCHG    BP, SP
          POP     SI
          XCHG    BP, SP
          $next

