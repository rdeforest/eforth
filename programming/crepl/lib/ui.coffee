# UserInterface abstract class

EventEmitter = require 'events'

abstract = (fn) -> throw new Error "not implemented"

class InputEvent
  constructor: (details) ->
    console.warn "Child of InputEvent called super() in its constructor, bad sign!"

class TextEvent extends InputEvent
  constructor: (@text) ->

class EventLog
  constructor: ->
    @eventId = 0
    @log = []

  add: (event) ->
    @log.push e = {id: @eventId++, event}
    e

class UserInterface extends EventEmitter
  @comment: """
    A UserInterface implementation provides a mapping from user activity to
    input and from output to user experience. Output is optionally associated
    with inputs to allow the client to give the user some indication of what
    caused various output events.
  """

  constructor: (@input, @output, @parser) ->
    @inputLog  = new EventLog
    @outputLog = new EventLog

    input.on 'command', @acceptInput.bind @

  acceptInput: (event) ->
    event = @inputLog.add event
    @parser.match event
    
  respondTo: (input, response) ->
    @genOutput response, {input}

  genOutput: abstract (output, {input} = {}) ->

class UserInterface.Readline extends UserInterface
  constructor: (@inStream, @outStream, @errStream) ->
    @rl = readline.createInterface
      input:   @inStream
      output: @outStream

Object.assign exports, {
  InputEvent, TextEvent, EventLog, UserInterface
}
