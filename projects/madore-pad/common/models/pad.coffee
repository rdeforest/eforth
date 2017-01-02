Crypto = require 'crypto'

module.exports = (Pad) ->
  Pad.fetch = (padName) ->
    if local = Pad.find padName
      return local

  Pad::makeHasher = ->
    Crypto.createHash @digestAlgorithm

  Pad::getDigest = ->
    hasher = @makeHasher()
    hasher.update @data
    hasher.digest @digestEncoding

  Pad::calculateFileName = ->
    @fileName = "pad-#{@hash.name}-#{@getDigest()}.dat"

  Pad.observe 'before save', (ctx, next) ->
    ctx.instance.calculateFileName()
    next()
