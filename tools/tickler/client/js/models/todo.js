/*global define*/
define([
  'underscore',
  'backbone',
  'common'
], function (_, Backbone, Common) {
  'use strict';

  var Todo = Backbone.Model.extend({
    defaults: {
      contents: '',
      acknowledged: 0,
      userId: function () { return Common.session.userId }
    },

    // Toggle the `completed` state of this todo item.
    toggle: function () {
      this.save({
        completed: !this.get('completed')
      });
    }
  });

  return Todo;
});
