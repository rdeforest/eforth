module.exports = ({make}) ->
  make 'ScheduledBeerEvent',
    schema:
      eventType:     String
      scheduledTime: Object
