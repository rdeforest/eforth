girlMod = require './girls'
global.matrix = ->
  traitList = __.values traits
  console.log (for girl in __.values girls
    [girl.name.left 8].concat(for trait in traitList
      (if trait in girl.traits
        trait.name
      else
        "").left 10)
    .join " ").join "\n"
        
girlMod.install()

