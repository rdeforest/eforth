define [ 'underscore', 'backbone', 'backboneLocalstorage', 'models/todo', 'common' ],
  (_, Backbone, Store, Todo, Common) ->
    new TodosCollection = Backbone.Collection.extend
        model: Todo
        url: Common.api('Items')
