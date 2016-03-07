define [ 'underscore', 'backbone', 'backboneLocalstorage', 'models/item', 'common' ],
  (_, Backbone, Store, Item, Common) ->
    new ItemsCollection = Backbone.Collection.extend
        model: Item
        url: Common.api('Items')
