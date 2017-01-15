module.exports = ({make}) ->
  make 'Request',
    schema:
      touristId  : String
      seats      : Number
      time       : Date
      fromStopId : String
      toStopId   : String
