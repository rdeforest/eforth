
secondsPerFrame = 2
framesShown     = 1

urls = """
  /page1.html
  /page2.html
  /page3.html
""".split /\n/


height = (Math.floor 100 / framesShown).toString() + "%"

getFrames = -> document.getElementsByTagName 'iframe'

if (getFrames()).length is 0
  console.log "adding frames"

  for url in urls
    frame = document.createElement 'iframe'
    frame.src = url
    document.body.appendChild frame


frameExtensions =
  display: (d) -> @style.display = d; this
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
  #f.style.height = height
  f.hide() if i >= framesShown

rotateFrames() for n in [1..6]

#setInterval rotateFrames, secondsPerFrame * 1000
