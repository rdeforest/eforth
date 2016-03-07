define [
    'jquery', 'underscore', 'backbone'
    'collections/items'
    'views/items'
    'common'
  ], ($, _, Backbone, Items, ItemView, Common, statsTemplate) ->
    itemTabView = Backbone.View.extend
      events:
        'keypress #new-item': 'createOnEnter'

      initialize: ->
        @$input      = @$ '#new-item'
        @$itemList   = @$ '#item-list'

        @listenTo Items, 'add', @addOne
        @listenTo Items, 'reset', @addAll
        @listenTo Items, 'all', _.debounce @render, 0

        Items.fetch reset:true

      addOne: (item) ->
        view = new ItemView model: item
        @$itemList.append view.render().el

      addAll: ->
        @$itemList.empty()
        Items.each @addOne, this

      createOnEnter: (e) ->
        if e.which is Common.ENTER_KEY and @$input.val().trim()
          Items.create
            contents: @$input.val().trim()
            userId: Common.session.userId
          @$input.val ''
