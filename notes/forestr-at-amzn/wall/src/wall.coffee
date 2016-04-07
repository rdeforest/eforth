
secondsPerFrame = 2
framesShown     = 2


height = (Math.floor 100 / framesShown).toString() + "%"

getFrames = -> document.getElementsByTagName 'iframe'

frameExtensions =
  display: (v) -> @style.display = v; this
  hide:        -> @display 'none'
  show:        -> @display 'inherit'
  bump:        -> @parentElement.appendChild this
  refresh:     -> @src = "" + this.src; this

proto = (getFrames()[0]).constructor.prototype

proto[name] = def for name, def of frameExtensions

rotateFrames = ->
  firstFrame = (frames = getFrames())[0]

  frames[framesShown].show()
  
  frames[0].hide().bump().refresh()

for f, i in getFrames()
  f.style.height = height
  f.hide() if i >= framesShown

setInterval rotateFrames, secondsPerFrame * 1000
