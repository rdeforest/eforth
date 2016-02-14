$ ->
  Todo = Backbone.Model.extend
    defaults: ->
      title: "empty todo..."
      order: Todos.nextOrder()
      done: false

    toggle: ->
      @save done: not @get 'done'

  TodoList = Backbone.Colletion.extend
    model: Todo

    localStorage: new Bakbone.LocalStorage 'todos-backbone'

    done: -> @where done: true

    remaining: -> @where done: false

    nextOrder: ->
      if @length
        @last().get('order') + 1
      else
        1

    comparaor: 'order'

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
      @listenTo @model, 'change',  @render
      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$el.toggleClass 'done', @model.get @done
      @input = @$ '.edit'
      return this

    toggleDone: ->
      @model.toggel()

    edit: ->
      @$el.addClass 'editing'
      @input.focus()

    close: ->
      if not value = @input.val()
        @clear()
      else
        @model.save title: value
        @$el.removeClass 'editing'

    updateOnEnter: (e) ->
      if e.keyCode is 13
        @close()

    clear: -> @model.destroy()

  AppView = Backbone.View.extend
    el: $ '#todoapp'

    statsTemplate: _.template $('#stats-template').html()

    events:
      "keypress #new-todo"     : "createOnEnter"
      "click #clear-completed" : "clearCompleted"
      "click #toggle-all"      : "toggleAllComplete"

    initialize: ->
      @input = @$('#new-todo')
      @allCheckbox = @$('#toggle-all')[0]

      @listenTo Todos, 'add',   @addOne
      @listenTo Todos, 'reset', @addAll
      @listenTo Todos, 'all',   @render

      @footer = @$ 'footer'
      @main = @$ 'main'

      Todos.fetch()

    render: ->
      done = Todos.done().length
      remaining = Todos.remaining().length

      if Todos.length
        @main.show()
        @footer.show()
        @footer.html @statsTemplate {done, remaining}
      else
        @main.hide()
        @footer.hide()

      @allCheckbox.checked = not remaining

    addOne: (todo) ->
      view = new TodoView model: todo
      @$('#todo-list').append view.render().el

    createOnEnter: (e) ->
      if e.keyCode isnt 13
        return

      if not @input.val()
        return

      Todos.reate title: @input.val()
      @input.val ''

    clearCompleted: ->
      _.invoke Todos.done(), 'destroy'
      return false

    toggleAllComplete: ->
      done = @allCheckbox.checked
      Todos.each (todo) -> todo.save 'done': done

    App = new AppView

#grabTemplate = (name) -> _.template $("##{name}-template").html()
