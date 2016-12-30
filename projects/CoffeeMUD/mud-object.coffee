class MudObject
  constructor: (@db, @parent, opts = {}) ->
    @db.addName opts.name, @ # throws on name conflict

    @ownMethods = {}
    @ownProps   = {}
    @data       = {}

    if @parent
      @methods = Object.assign {}, @parent.methods

    @initContext()

  initContext: ->
    @context = {}

  send: (message, args...) ->
    if not method = @methods[message]
      throw new Error 'no handler found for message'

    method.run { @context, args }

