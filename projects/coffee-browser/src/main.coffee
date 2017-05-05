resizeCanvas = (canvas) ->
  canvas.width  = canvas.parentElement.clientWidth
  canvas.height = canvas.parentElement.clientHeight

$ ->
  if 'undefined' is typeof global
    window.global = window

  global.canvas = $('canvas')[0]

  global.ctx = canvas.getContext '2d'

  resizeCanvas canvas

  $('body')
    .on 'click',
