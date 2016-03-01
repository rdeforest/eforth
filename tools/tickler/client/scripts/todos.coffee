$ ->
  Item = Backbone.Model.extend
    defaults: ->
      contents: "empty item..."
      order: itemList.nextOrder()
      done: false
      acknowledged: 0

    toggle: -> @save done: not @get 'done'

  ItemList = Backbone.Collection.extend
    model: Item
    #localStorage: new Backbone.LocalStorage 'todos-backbone'
    url: '/api/v1/Items'
    comparator: 'order'

    done: ->
      @where done: true
    remaining: ->
      @where done: false
    nextOrder: ->
      if not @length then 1 else @last().get('order') + 1

  itemList = new ItemList

  ItemView = Backbone.View.extend
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
      if value = @input.val()
        @model.save contents: value
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

      @listenTo itemList, 'add',   @addOne
      @listenTo itemList, 'reset', @addAll
      @listenTo itemList, 'all',   @render

      @footer = @$('footer')
      @itemList = $('#itemList')

      itemList.fetch()

    render: ->
      done = itemList.done().length
      remaining = itemList.remaining().length

      if itemList.length
        @itemList.show()
        @footer.show()
        @footer.html @statsTemplate {done, remaining}
      else
        @itemList.hide()
        @footer.hide()

      @allCheckbox.checked = not remaining

    addOne: (todo) ->
      view = new ItemView model: todo
      @$("#todo-list").append view.render().el

    addAll: -> itemList.each @addOne, this

    createOnEnter: (e) ->
      if e.keyCode is 13 and @input.val()
        itemList.create contents: @input.val()
        @input.val ''

    clearCompleted: ->
      _.invoke itemList.done(), 'destroy'
      return false

    toggleAllComplete: ->
      done = @allCheckbox.checked
      itemList.each (todo) -> todo.save done: done

  App = new AppView

  $("#todoapp").tabs
    active: 0

