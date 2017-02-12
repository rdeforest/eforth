{Writable} = require 'stream'

module.exports =
  test: ->
    global.dict = '/usr/share/dict/words'
    global.read = (f) -> fs.createReadStream f
    global.BPA  = prefix.bestPrefixArea

  bestPrefixArea: class extends Writable
    constructor: (@n, cb) ->
      super

      @competing = {}
      @prev = ''
      @topN = []
      @buffer = Buffer.of()

      @on 'finish', =>
        @lines.push @buffer.toString()
        @reduceTopN()
        cb @topN

    reduceTopN: ->
      return unless @topN.length > @n
      @topN = (@topN.sort (a, b) -> b.score - a.score)[0..@n - 1]

    _write: (chunk, encoding, callback) =>
      ridx = Buffer.
      most = 0

      if 'function' isnt typeof word.startsWith
        console.log word
        return callback null

      for pfx, soFar of @competing when word.startsWith pfx
        soFar.push word
        soFar.score += pfx.length

      @topN.push (@competing[word] = []).score = word.length

      unless word.startsWith @prev
        @reduceTopN()


