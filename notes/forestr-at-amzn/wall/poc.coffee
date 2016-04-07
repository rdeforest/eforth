resizeFrame = (frame) ->
  frame.width = frame.height = "100%"

hideFrame = (frame) -> frame.style.display = 'none'

showFrame = (frame) -> frame.style.display = 'inherit'

hideAndResizeFrames = ->
  frames = document.findByTagName('iframe')

  for frame in frames
    resizeFrame frame
    hideFrae frame

  frames

frames = hideAndResizeFrames()
secondsPerFrame = 10
task = null

startFlipping = ({frames, secondsPerFrame}) ->
  interval = secondsPerFrame * 1000

  curFrame = 0
  nextFrame = ->
    [prevFrame, curFrame] = [curFrame, (curFrame + 1) % frames.length]
    showFrame frames[curFrame]
    hideFrame frames[prevFrame]

  task = setInterval nextFrame, interval

startFlipping {frames, secondsPerFrame}

