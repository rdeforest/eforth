module.exports.FrameBuffer =
  class FrameBuffer
    constructor: (@canvas) ->
      {@width, @height} = @canvas
      @backplane =
      

module.exports.init = (modules) ->
  {$} = modules
