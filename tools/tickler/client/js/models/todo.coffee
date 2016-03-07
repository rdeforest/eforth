define [ 'underscore', 'backbone', 'common' ],
  (_, Backbone, Common) ->
    Todo = Backbone.Model.extend
      defaults:
        contents: 'No contents specified'
        acknowledged: 0
        userId: -> Common.session.userId

      # Retained as example
      ###
      toggle: function () {
        this.save({
          completed: !this.get('completed')
        });
      }
      ###
