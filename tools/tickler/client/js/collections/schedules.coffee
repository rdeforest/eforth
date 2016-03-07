define [ 'underscore', 'backbone', 'models/schedule', 'common' ],
  (_, Backbone, Schedule, Common) ->
    new SchedulesCollection = Backbone.Collection.extend
        model: Schedule
        url: Common.api('Schedules')
