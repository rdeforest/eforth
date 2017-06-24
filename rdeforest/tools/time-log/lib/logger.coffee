extend = (require 'underscore').extendOwn

tuple = (key, value) -> (o = {})[key] = value; o

# Generates functions which convert data and a list of objects into a list of
# objects with that data added to them. The 'specifics' is an object.

specifier = (modifier) ->
  modify = (specifics, entries...) ->
    entries
      .map (entry) ->
        # XXX: DANGER WILL ROBINSON
        # This means an entry with a length key will BREAK EVERYTHING :(
        # However, since entry() puts user data in 'details' and 'notes', we
        # don't have to worry about that happening any time soon. YAY :)
        if entry.length
          modify specifics, entry...
        else
          [modifier specifics, entry]
      .reduce (a, b) -> a.concat b


# Generates modifiers consumed by 'specifier' above. The specifics 
# are associated with the key name provided.
#
# This exists to simplify creation of 'year' and such. Instead of
#
#     year = specifier (value, entry) -> extend {year: value}, entry
#
# It's just
#
#     year = container 'year'

container = (fieldName) ->
  specifier (value, entry) ->
    extend tuple(fieldName, value), entry


# Generates a function which turns a value and some elements into
# an object with a "type" property set to the specified type, the "time"
# property to the value given in the entry and the "details" to the merged
# values provided.

entry = (type) ->
  (time, details...) ->
    notes = notes: []

    details = details.filter (detail) ->
      if 'object' is typeof detail
        true
      else
        # I swear this is simpler than the alternatives
        notes.notes.push detail
        false

    # Still swearing...
    if not notes.notes.length
      notes = {}

    extend {type, time}, details..., notes

module.exports = logger =
  _: {specifier, container, entry}
  log: log = []
  q: {}
  entries: (entries) -> entries?.length and log.concat entries
  start: entry 'start'
  stop:  entry 'stop'
  year:  container 'year'
  month: container 'month'
  day:   container 'day'
