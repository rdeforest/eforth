# 'drama' function takes a series of stage directions and renders them into the script
drama = (args...) ->
  for event in args
    if 'string' is typeof event
      narrator event
    
Actor = ({@name, @desc, @poses}) ->
  newActor = (actions...) -> actions.each

  newActor.prototype = {}


