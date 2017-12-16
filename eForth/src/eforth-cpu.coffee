
  class EForthCPU extends CPU
    constructor: (opts = {}) ->
      super
        registerNames: EForthRegisters
        opCodes:EForthOpcodes
        memory: EForthMemory


