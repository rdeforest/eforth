# Model

A Model is like a class with extra features like


    Model = (info) ->
      {name, has, hasMany, belongsTo, does} = info

      if not name
        throw new Error "Anonymous Model not supported."

      model = Object.create Model.prototype

    Object.assign Model,

These are class methods and properties.

      prototype:

These are the instance methods for Models, not the instance methods for
instances of a given Model. Model::create spawns instances.

        create: (info) ->
          instance = Object.create @prototype

          for iface in @interfaces and iface.init?
            ret = iface.init.apply instance, info

            if 'object' is typeof ret
              instance = ret

          instance.does = @does

        does: (iface) ->
          iface in @interfaces

        prototype:

Here is where we define methods on instances of instances of Model

          does: (iface) -> Object.getPrototypeOf(this).does iface
          as: (iface, methodName, args...) ->
            if not iface.does methodName
              throw new Error "#{methodName} is not a method of #{iface.name}"

            if not @does iface
              if not iface.worksOn this
                throw new Error "target doesn't do #{iface.name}"

              return iface.methods[methodName].apply this, args






# Model::instance::as iface, methodName, args...

  Treat target as if it were an instance of 'iface'

        as: (iface) ->

# Model::instance::create info



        create: (info) ->

# Model::instance::addBelongsTo otherClasses



        addBelongsTo: (others) ->



