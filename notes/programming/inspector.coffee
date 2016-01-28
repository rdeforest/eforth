util = require 'util'

namedConstant = (type, name) -> {type: type, name: name}

unique  = (name) -> namedConstant 'unique', name
number  = (name) -> namedConstant 'number', name
boolean = (name) -> namedConstant 'boolean', name

regularTypes = [
    1
    'one'

  ].map (v) -> typeof v

module.exports =
  inspect: (data) ->
    if data is null       then return unique 'null'
    if data is undefined  then return unique 'undefined'
    if data is NaN        then return number 'NaN'
    if data is Infinity   then return number 'Infinity'
    if data is false      then return boolean false
    if data is true       then return boolean true

    t = typeof data

    if t is 'number' then return type: t, value: data
    if t is 'string' then return type: t, value: data

  display: (inspection) ->
