{Watcher} = require './watcher'

fnArgs = (fn) -> fn.toString().match(/^function [^(]*\([^)]*\)/)[1]

mutationEvents = """
    defineProperty
    deleteProperty
    preventExtensions
    set
    setPrototypeOf
  """.split /\s+/

class Documentation
  @docs    : Symbol 'Documentation.docs'
  @getDocs : (subject) -> subject[@docs]
  @diagram : (subject) -> @getDocs(subject).diagram()

  constructor: (@subject) ->
    @cwatcher  = new Watcher @subject
    @pWatcher = new Watcher @subject::
    @methods  = {}
    @props    = {}
    @calls    = {}
    @calledBy = {}
    @parent   = @subject.constructor
    @children = []

    for name, desc of Object.getOwnPropertyDescriptors  @subject
      if 'function' is typeof desc.value
        args = fnArgs fn

        @methods[name] = { name, args, desc }
      else
        @props[name] = desc

    @subject[@docs] = @
    ce = ({target, name, args}) => @classEvent name, args
    pe = ({target, name, args}) => @protoEvent name, args

    for e in mutationEvents
      @cwatcher.on e, ce
      @pwatcher.on e, pe

  classEvent: (name, args) ->

  protoEvent: (name, args) ->

create = (klass) ->
  (new Documentation klass).cwatcher

Object.assign module.exports, {create, Documentation}

# usage:
#
#     docs = create class Foo
#       @handleDocEvent: (event, details...) ->
#
#       constructor: (...) ->
#         docs.on 'notifySubject', Foo.handleDocEvent
#           
