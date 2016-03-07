define [
    'jquery', 'underscore', 'backbone'
    'collections/todos'
    'views/todos'
    'common'
    'text!templates/stats.html'
  ], ($, _, Backbone, Todos, TodoView, Common, statsTemplate) ->
    AppView = Backbone.View.extend
      el: '#todoapp'

      template: _.template statsTemplate

      events:
        'keypress #new-todo': 'createOnEnter'

      initialize: ->
        @$input      = @$ '#new-todo'
        @$footer     = @$ '#footer'
        @$main       = @$ '#main'
        @$todoList   = @$ '#todo-list'

        @listenTo Todos, 'add', @addOne
        @listenTo Todos, 'reset', @addAll
        @listenTo Todos, 'filter', @filterAll
        @listenTo Todos, 'all', _.debounce @render, 0

        Todos.fetch reset:true

      render: ->
        if Todos.length
          @$main.show()
          @$footer.show()

          @$footer.html @template()
        else
          @$main.hide()
          @$footer.hide()

      addOne: (todo) ->
        view = new TodoView model: todo
        @$todoList.append view.render().el

      addAll: ->
        @$todoList.empty()
        Todos.each @addOne, this

      filterOne: (todo) -> todo.trigger 'visible'

      filterAll: -> Todos.each @filterOne, this

      createOnEnter: (e) ->
        if e.which is Common.ENTER_KEY and @$input.val().trim()
          Todos.create
            contents: @$input.val().trim()
            userId: Common.session.userId
          @$input.val ''
