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

Object.assign module.exports, {Memory}
