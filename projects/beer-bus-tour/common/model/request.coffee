dynogels  = require 'dynogels'

module.exports = ({make, Joi}) ->
  make 'Request',
    schema:
      touristId         : Joi.string()
      seats             : Joi.number()
      time              : Joi.date()
      fromStopId        : Joi.string()
      toStopId          : Joi.string()
