models = [
    class Building
      constructor: (@maxTime = 4 * 60) ->
        @uses = 0
        @town = new Town

      nextUseOutput: (girl) ->
        output = {}

        for name, resource in resourceNames
          if 'function' is typeof this[fName = 'nextUse' + name]
            output[resource.name] = this[fname] girl

      nextUseTime: -> min [@maxTime, (Math.ceil(@uses / 2) + 1) * 15]

      use: (girl) -> @uses++

      click: -> # virtual method, but it's OK to not override it

    class TrainingBuilding extends Building
      constructor: (@skill) ->
        super undefined, 8

      # Depends on girl's skill/style, don't know formula yet
      nextUseTime: (girl) -> girl.attr[@skill].

      click: (girl) ->
        girl.attr[@skill].addPoints @town.gatherRate[@skill]


    class ResourceBuilding extends Building
      constructor: (maxTime) ->
        super undefined, maxTime


    class CamBuilding extends ResourceBuilding
      constructor: ->
        super 12

      nextUseOutput: (girl) ->
        Object.assign super girl,
          money: girl.camGross()
          fans: girl.camFans()


    class PhotoBuilding extends ResourceBuilding
      constructor: ->
        super 8

      nextUseOutput: (girl) ->
        Object.assign super girl,
          fans: girl.photoFans()
  ]

for model in models
  module.exports[model.name] = model
