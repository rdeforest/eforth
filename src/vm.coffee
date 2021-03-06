module.exports = (injected) ->
  { Memory, InputOutput, Processor } = injected

  Register IP: {}
  Register WP: {}
  Register SP: {}
  Register RP: {}
  Register UP: {}

  Opcode LODSW: undefined
  Opcode JMP:  'address'
  Opcode XCHG: 'src', 'dst'
  Opcode PUSH: 'src'
  Opcode POP:  'dst'

  Macro $NEXT: LODSW, Opcode.JMP Register.AX

  # These should be in kernel.coffee or something
  NativeWord doLIST:
  [ # ( a -- ) # Run address list in a colon word.
    XCHG BP,SP # exchange pointers
    PUSH SI    # push return stack
    XCHG BP,SP # restore the pointers
    POP  SI    # new list address
    $NEXT
  ]

  NativeWord EXIT:
  [            # Terminate a colon definition.
    XCHG BP,SP # exchange pointers
    POP  SI    # pop return stack
    XCHG BP,SP # restore the pointers
    $NEXT
  ]

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
