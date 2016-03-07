define [ 'jquery', 'backbone', 'collections/items', 'common' ],
  ($, Backbone, Items, Common) ->

    ItemRouter = Backbone.Router.extend
      routes: '*filter': 'setFilter'

      setFilter: (param) ->
        # Set the current filter to be used
        Common.ItemFilter = param || ''

        # Trigger a collection filter event, causing hiding/unhiding
        # of the Item view items
        Items.trigger 'filter'
