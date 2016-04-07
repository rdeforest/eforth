resizeFrame = (frame) -> frame.width = frame.height = "100%"

hideFrame = (frame) -> frame.style.display = 'none'

showFrame = (frame) -> frame.style.display = 'inherit'

hideAndResizeFrames = ->
  frames = document.getElementsByTagName 'iframe'

  for frame in frames
    resizeFrame frame
    hideFrame frame

  frames

frames = hideAndResizeFrames()
showFrame frames[0]
secondsPerFrame = 3
task = null

startFlipping = ({frames, secondsPerFrame}) ->
  interval = secondsPerFrame * 1000

  curFrameIdx = prevFrameIdx = 0
  curFrame = prevFrame = frames[curFrameIdx]

  nextFrame = ->
    [prevFrameIdx, curFrameIdx] = [curFrameIdx, (curFrameIdx + 1) % frames.length]
    [prevFrame, curFrame] = [curFrame, frames[curFrameIdx]]

    console.log "flipping from #{prevFrame.src} to #{curFrame.src}"

    showFrame curFrame
    hideFrame prevFrame

  task = setInterval nextFrame, interval

startFlipping {frames, secondsPerFrame}

window.frames = frames
window.task = task
