define [
    'jquery', 'underscore', 'backbone'
    'views/itemTab'
    'views/scheduleTab'
  ], ($, _, Backbone, itemTabView, scheduleTabView)->
    AppView = Backbone.View.extend
      el: '#ticklerapp'

      initialize: ->
        @$el.tabs()

        new itemTabView     el: '#items'
        new scheduleTabView el: '#schedules'
