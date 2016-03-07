define [
    'jquery', 'underscore', 'backbone'
    'collections/items'
    'views/items'
    'common'
    'text!templates/stats.html'
  ], ($, _, Backbone, Items, ItemView, Common, statsTemplate) ->
    AppView = Backbone.View.extend
      el: '#ticklerapp'

      template: _.template statsTemplate

      events:
        'keypress #new-item': 'createOnEnter'

      initialize: ->
        @$input      = @$ '#new-item'
        @$footer     = @$ '#footer'
        @$main       = @$ '#main'
        @$itemList   = @$ '#item-list'

        @listenTo Items, 'add', @addOne
        @listenTo Items, 'reset', @addAll
        @listenTo Items, 'all', _.debounce @render, 0

        Items.fetch reset:true
        $("#ticklerapp").tabs()

      render: ->
        if Items.length
          @$main.show()
          @$footer.show()

          @$footer.html @template()
        else
          @$main.hide()
          @$footer.hide()

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
