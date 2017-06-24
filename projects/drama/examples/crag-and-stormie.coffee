{Actor, Pose, Script, Drama} = require '../lib/drama'

examplePlay = Script
  options: standardPlayers: true
  players:
    crag: Actor
      name: "Crag"
      desc: "Swarthy"
      poses:
        default: Pose "... sturdy ..."
        onGuard: Pose "..."
    stormagnet: Actor
      name: "Stormagnet"
      desc: "Mysterious"
      poses:
        default: Pose "..."

examplePlay.script = Script
  title: "Crag and Stormagnet"

drama = Drama script: examplePlay

{crag, stormagnet, stage, narrator} = drama.players

cr = crag
sm = stormagnet

drama "",
  stage
    .setting "apartment"
    .curtainUp()

  cr "Today is a good day to paint."
    .commencePainting
  cr "That's odd..."
    .leanIn
    .fallForward

  stage
    .lightsDown
    .changeSet "painting", sounds: "splashing"
    .lightsUp

  cr "Where am I?!"

  sm "More importabtly, _who_ are you?"
