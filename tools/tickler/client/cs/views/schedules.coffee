define [  'jquery', 'underscore', 'backbone'
          'common', 'text!templates/schedules.html' ],
  ($, _, Backbone, Common, schedulesTemplate) ->
    ScheduleView = Backbone.View.extend
      tagName: 'tr'
      template: _.template schedulesTemplate
      events:
        'dblclick label' : 'edit'
        'click .destroy' : 'clear'
        'keypress .edit' : 'updateOnEnter'
        'keydown .edit'  : 'revertOnEscape'
        'blur .edit'     : 'close'

      initialize: ->
        @listenTo @model, 'change', @render
        @listenTo @model, 'destroy', @remove

      render: ->
        @$el.html @template @model.toJSON()

        @$input = @$('.edit')
        this

      edit: ->
        @$el.addClass 'editing'
        @$input.focus()

      close: ->
        value = @$input.val()
        trimmedValue = value.trim()

        if trimmedValue
          @model.save contents: trimmedValue

          if value isnt trimmedValue
            @model.trigger 'change'
        else
          @clear()

        @$el.removeClass 'editing'

      updateOnEnter: (e) ->
        if e.keyCode is Common.ENTER_KEY
          @close()

      revertOnEscape: (e) ->
        if e.which is Common.ESCAPE_KEY
          @$el.removeClass 'editing'
          @$input.val @model.get 'contents'

      clear: -> @model.destroy()
