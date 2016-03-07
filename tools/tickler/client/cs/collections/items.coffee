define [ 'underscore', 'backbone', 'models/item', 'common' ],
  (_, Backbone, Item, Common) ->
    new ItemsCollection = Backbone.Collection.extend
        model: Item
        url: Common.api('Items')
