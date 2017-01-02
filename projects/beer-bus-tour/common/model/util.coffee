config   = require '../config'
Joi      = require 'joi'
dynogels = require 'dynogels'

module.exports = Object.assign {Joi, dynogels, config},
  # usage
  #   module.exports = ({make, Joi}) ->
  #     MyClass = make 'MyClass',
  #       schema:
  #         foo: 'string'
  #         bar: 'object'
  #         baz: Joi.array().items(Joi.string())

  make: (className, description) ->
    if not description.hashKey
      description.hashKey = 'id'
      (description.schema ?= {})
        .id ?= dynogels.types.uuid()`

    for prop, desc of description.schema?
      tName =
        switch desc
          when Object, String, Boolean, Number, Array, Date
            desc.name.toLowerCase()
          else desc

      description.schema[prop] = Joi[tName]?()

    dynogels.define className, description
