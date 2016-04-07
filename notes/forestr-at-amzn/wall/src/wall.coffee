secondsPerFrame = 2
framesShown     = 1

height = (Math.floor 100 / framesShown).toString() + "%"

getFrames = -> document.getElementsByTagName 'iframe'

IFrame = (document.createElement 'iframe').constructor
IFrame.prototype[name] = def for name, def of (
    display: (d) -> @style.display = d; this
    hide:        -> @display 'none'
    show:        -> @display 'inherit'
    bump:        -> @parentElement.appendChild this
    refresh:     -> @src = "" + this.src; this
  )

rotateFrames = (frames) ->
  frames[framesShown].show()
  frames[0].hide().bump().refresh()

for f, i in getFrames()
  f.style.height = height
  f.hide() if i >= framesShown

setInterval (-> rotateFrames getFrames()), secondsPerFrame * 1000
