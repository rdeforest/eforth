moment        = require 'moment'

{ Persisted } = require './persisted'
{ Event     } = require './event'

class Managed extends Persisted
  constructor: (opts = {}) ->
    super opts

    { @description
      @predecessor
      @changed
      @deleted
    } = opts

    if @predecessor and not @store.has @predecessor
      throw new Error "Predecessor '#{o}' not found in store\n" +
                      "Cross-store references not yet supported."

    @description = '' if @description in [null, undefined]

    if typeof @description not in ['string', 'buffer']
      throw new Error "Description must be a string or buffer"

    @changed ?= new Event {time, opts.owner}
    @deleted = not not @deleted

  history: ->
    # XXX: 2017-11-25 - Tail recursion would be great here, but it's not well
    # supported in V8 yet.

    versions = [v = @]

    while prev = v.predecessor and v = @store.get prev
      versions.unshift v

    versions

  successor: -> @store.findSuccessor @

  latest: ->
    succ = null
    next = @
    (succ = next) while next = @successor next
    succ

  createNext: ->

Object.assign module.exports, { Managed }

