module.exports = ({make}) ->
  make 'ActualBeerEvent',
    schema:
      scheduled : 'string'
      actualTime: 'date'
