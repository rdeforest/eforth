## ColdObject

ColdObject handles the MOP:

- add/remove parent
- add/remove objectVar
- add/remove method
- receive message

It exists outside the context of ColdPress methods which interact through
proxies.

    mixin = require './non-cold/mixin'

    Inheritor = require './inheritor'
    ColdVars = require './var'
    MessageReceiver = require './msg-receiver'

    class ColdObject
      constructor: (@db, parent) ->
        @storage = @db.create()
        @setParent parent


    mixin ColdObject, Inheritor, ColdVars, MessageReciver,

      setParent: (parent) ->

      parentMethodCollisions: (parent) ->
        _.intersection @allMethods(), parent.allMethods()

      addParent: (parent) ->
        if @parentMethodCollisions(parent).length
          throw new Error '..'

        for method in parent.allMethods()
          @inheritedMethods[method.name] = method

