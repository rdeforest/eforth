define [ 'jquery', 'backbone', 'collections/todos', 'common' ],
  ($, Backbone, Todos, Common) ->

    TodoRouter = Backbone.Router.extend
      routes: '*filter': 'setFilter'

      setFilter: (param) ->
        # Set the current filter to be used
        Common.TodoFilter = param || ''

        # Trigger a collection filter event, causing hiding/unhiding
        # of the Todo view items
        Todos.trigger 'filter'
