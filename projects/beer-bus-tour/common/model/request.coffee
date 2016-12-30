dynogels  = require 'dynogels'

module.exports =
  Request = dynogels.define 'Request',
    schema:
      touristId         : Joi.string()
      seats             : Joi.number()
      time              : Joi.date()
      fromStopId        : Joi.string()
      toStopId          : Joi.string()
