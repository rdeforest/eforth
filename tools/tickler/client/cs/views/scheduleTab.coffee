define [
    'jquery', 'underscore', 'backbone'
    'collections/schedules'
    'views/schedules'
    'common'
  ], ($, _, Backbone, Schedules, ScheduleView, Common, statsTemplate) ->
    scheduleTabView = Backbone.View.extend
      Schedules: Schedules
      events:
        'keypress #new-schedule': 'createOnEnter'

      initialize: ->
        @$input      = @$ '#new-schedule'
        @$scheduleList   = @$ '#schedule-list'

        @listenTo Schedules, 'add', @addOne
        @listenTo Schedules, 'reset', @addAll
        @listenTo Schedules, 'all', _.debounce @render, 0

        Schedules.fetch reset:true

      addOne: (schedule) ->
        view = new ScheduleView model: schedule
        @$scheduleList.append view.render().el

      addAll: ->
        @$scheduleList.empty()
        Schedules.each @addOne, this

      createOnEnter: (e) ->
        if e.which is Common.ENTER_KEY and @$input.val().trim()
          Schedules.create
            interval: @$input.val().trim()
            userId: Common.session.userId
          @$input.val ''
