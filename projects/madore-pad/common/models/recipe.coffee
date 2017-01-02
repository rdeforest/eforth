module.exports = (Recipe) ->
  Recipe::fetchPad = (padName) ->
    Recipe.getApp().models.Pad.fetch padName

  Recipe::fetchPads = ->
    for name, idx in @padNames
      @pads[idx] = @fetchPad name unless @pads[idx]

  Recipe::assemble = ->
    @fetchPads()
    assembled = Buffer.unsafeAlloc @longestPad
    longestLength = 0

    pads = @pads
      .sort (a, b) -> a.length - b.length
      .map (pad) ->
        pad =
          if extra = pad.length % 4
            extended = Buffer.allocUnsafe pad.length + 4 - extra
            Buffer.copy extended, pad
            extended
          else
            pad

        longestLength = Math.max pad.length, longestLength
        pad

    for offset in [0 .. longestLength >> 2]
      total = 0

      while pads[0].length < offset + 3
        pads.shift()

      for pad in pads
        total ^= pad.readUInt32BE offset

      assembled.writeUInt32BE total, offset

