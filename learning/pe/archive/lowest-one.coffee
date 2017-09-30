assert = require 'assert'

module.exports = (config) ->
  {WORD_SIZE} = config

  return lowestOneBit = (word) ->
    if not word
      return -1

    mask = -1 >>> shift = WORD_SIZE >>> 1
    bit = 0
    loops = 0

    loop
      assert loops++ < WORD_SIZE

      # lowest bit in low side of tested area
      if word & mask
        if word & 0x1
          return bit

      # lowest bit in high side
      else
        word >>>= shift
        bit += shift

      mask >>>= (shift >>>= 1)
