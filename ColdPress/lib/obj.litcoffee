## ColdObject

ColdObject handles the MOP:

- add/remove parent
- add/remove objectVar
- add/remove method
- receive message

    mixin = require './non-cold/mixin'

    Inheritor = require './inheritor'
    ColdVars = require './var'
    MessageReceiver = require './msg-receiver'

    class ColdObject

    mixin ColdObject, Inheritor, ColdVars, MessageReciver

      addChild: (child) ->

      parentMethodCollisions: (parent) ->
        _.intersection @allMethods(), parent.allMethods()

      addParent: (parent) ->
        if @parentMethodCollisions(parent).length
          throw new Error '..'

        for method in parent.allMethods()
          @inheritedMethods[method.name] = method

