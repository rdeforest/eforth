# Why not extend Object?

This approach is fun but dangerous (much like ...). Keeping our changes
contained makes use by others more flexible and not "all or nothing."

If we ever finish the basic functionality we might add an option to "monkey
patch" the core Node and JavaScript classes.

# Model

A Model is a class with extra features.

    Model = (info) ->
      {name, has, hasMany, belongsTo, does} = info

      if not name
        throw new Error "Anonymous Model not supported."

      model = Object.assign Object.create(Model.prototype),
        constructor: this
        {name}

      for attrName, attrInfo of has or {}
        MOP.addAttribute model, attrName, attrInfo

      for relName, relInfo of hasMany or {}
        MOP.addHasMany model, relName, relInfo

      for relName, relInfo of belongsTo or {}
        MOP.addBelongsTo model, relName, relInfo

      for ifName, ifInfo of does or {}
        MOP.addIFace model, ifName, ifInfo

      model

    Object.assign Model,

These are methods and properties of Model itself.

      registered: {}

These are the methods and properties for instances of Model, not the instance
methods for instances of a given Model. Model() creates new models. (model =
Model())() spawns an instance of model.

      prototype:
        (info) ->
          instance = Object.create @prototype
          instance.constructor = this

          for iface in @interfaces and iface.init?
            ret = iface.init.apply instance, info

            if 'object' is typeof ret
              instance = ret

    Object.assign Model.prototype,
      does: (iface) ->
        iface in @interfaces

These are the default/minimum methods and properties on instances of instances
of Model.

      prototype:
        does: (iface) -> @constructor.does iface

# Model::instance::as iface, methodName, args...

  Treat target as if it were an instance of 'iface'

        as: (iface, methodName, args...) ->
          if not iface.does methodName
            throw new Error "#{methodName} is not a method of #{iface.name}"

          if not @does iface
            if not iface.worksOn this
              throw new Error "target doesn't do #{iface.name}"

            return iface.methods[methodName].apply this, args

# Model::instance::create info

        create: (info) ->

# Model::instance::addBelongsTo otherClasses

        addBelongsTo: (others) ->



