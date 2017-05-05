if 'undefined' is typeof global
  window.global = window

global.canvas = $('canvas')

global.ctx = canvas.getContext '2d'
