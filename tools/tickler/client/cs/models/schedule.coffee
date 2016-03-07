define [ 'underscore', 'backbone', 'common' ],
  (_, Backbone, Common) ->
    Schedule = Backbone.Model.extend
      defaults:
        interval: 86400 * 1000
        participantId: Common.session.userId

      # Retained as example
      ###
      toggle: function () {
        this.save({
          completed: !this.get('completed')
        });
      }
      ###
