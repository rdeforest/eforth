# Config
secondsPerFrame = 3

hideFrame = (frame) -> frame.style.display = 'none'

showFrame = (frame) -> frame.style.display = 'inherit'

reloadFrame = (frame) ->
  [url, refresh = 0] = frame.src.split '?'
  refresh++
  frame.src = url + '?' + refresh


startFlipping = ({frames, secondsPerFrame}) ->
  interval = secondsPerFrame * 1000

  nextFrame = ->
    [prevFrame, curFrame, rest...] = frames
    frames = [curFrame, rest..., prevFrame]

    console.log "flipping from #{prevFrame.src} to #{curFrame.src}"

    showFrame curFrame
    hideFrame prevFrame
    reloadFrame prevFrame

  setInterval nextFrame, interval

# start
for frame in (frames = document.getElementsByTagName 'iframe')
  frame.width = frame.height = "100%"
  hideFrame frame

showFrame frames[0]

startFlipping {frames, secondsPerFrame}


