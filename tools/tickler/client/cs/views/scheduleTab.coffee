define [
    'jquery', 'underscore', 'backbone'
    'collections/schedules'
    'views/schedules'
    'common'
  ], ($, _, Backbone, Schedules, ScheduleView, Common, statsTemplate) ->
    itemTabView = Backbone.View.extend
      events:
        'keypress #new-item': 'createOnEnter'

      initialize: ->
        @$input      = @$ '#new-item'
        @$itemList   = @$ '#item-list'

        @listenTo Schedules, 'add', @addOne
        @listenTo Schedules, 'reset', @addAll
        @listenTo Schedules, 'all', _.debounce @render, 0

        Schedules.fetch reset:true

      addOne: (item) ->
        view = new ScheduleView model: item
        @$itemList.append view.render().el

      addAll: ->
        @$itemList.empty()
        Schedules.each @addOne, this

      createOnEnter: (e) ->
        if e.which is Common.ENTER_KEY and @$input.val().trim()
          Schedules.create
            interval: @$input.val().trim()
            userId: Common.session.userId
          @$input.val ''
