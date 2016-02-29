$ ->
  Todo = Backbone.Model.extend
    defaults: ->
      title: "empty item..."
      order: Todos.nextOrder()
      done: false

    toggle: -> @save done: not @get 'done'

  TodoList = Backbone.Collection.extend
    model: Todo
    localStorage: new Backbone.LocalStorage 'todos-backbone'
    done: -> @where done: true
    remaining: -> @where done: false
    nextOrder: -> if not @length then 1 else @last().get('order') + 1
    comparator: 'order'

  # XXX: Capitalized but not a class? Maybe change that?
  Todos = new TodoList

  TodoView = Backbone.View.extend
    tagName: 'li'
    template: _.template $('#item-template').html()

    events:
      "click .toggle"   : "toggleDone"
      "dblclick .view"  : "edit"
      "click a.destroy" : "clear"
      "keypress .edit"  : "updateOnEnter"
      "blur .edit"      : "close"

    initialize: ->
      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$el.toggleClass 'done', @model.get 'done'
      @input = @$ '.edit'
      this

    toggleDone: -> @model.toggle()

    edit: ->
      @$el.addClass 'editing'
      @input.focus()

    close: ->
      if value = @input.val
        @model.save title: value
        @$el.removeClass 'editing'
      else
        @clear()

    updateOnEnter: (e) ->
      if e.keyCode is 13
        @close()

    clear: -> @model.destroy()

  AppView = Backbone.View.extend
    el: $("#todoapp")
    statsTemplate: _.template $('#stats-template').html()
    events:
      "keypress #new-todo":  "createOnEnter"
      "click #clear-completed": "clearCompleted"
      "click #toggle-all": "toggleAllComplete"

    initialize: ->
      @input = @$("#new-todo")
      @allCheckbox = @$("#toggle-all")[0]

      @listenTo Todos, 'add',   @addOne
      @listenTo Todos, 'reset', @addAll
      @listenTo Todos, 'all',   @render

      @footer = @$('footer')
      @itemList = $('#itemList')

      Todos.fetch()

    render: ->
      done = Todos.done().length
      remaining = Todos.remaining().length

      if Todos.length
        @itemList.show()
        @footer.show()
        @footer.html @statsTemplate {done, remaining}
      else
        @itemList.hide()
        @footer.hide()

      @allCheckbox.checked = not remaining

    addOne: (todo) ->
      view = new TodoView model: todo
      @$("#todo-list").append view.render().el

    addAll: -> Todos.each @addOne, this

    createOnEnter: (e) ->
      if e.keyCode is 13 and @input.val()
        Todos.create title: @input.val()
        @input.val ''

    clearCompleted: ->
      _.invoke Todos.done(), 'destroy'
      return false

    toggleAllComplete: ->
      done = @allCheckbox.checked
      Todos.each (todo) -> todo.save done: done

  App = new AppView

  $("#todoapp").tabs()

