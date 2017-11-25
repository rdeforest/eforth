moment        = require 'moment'

{ Persisted } = require './persisted'

class Event extends Persisted
  constructor: ({@time, @owner}) ->

Object.assign module.exports, { Event }

