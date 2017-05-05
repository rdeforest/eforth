growingPlant = (upSpeed, downSpeed, desiredHeight) ->
  daily = upSpeed - downSpeed

  if upSpeed > desiredHeight
    return 1

  Math.floor desiredHeight / daily

(require './genericTester') [
  [ [100, 10, 910], 10 ]
  [ [10, 9, 4], 1 ]
], growingPlant

