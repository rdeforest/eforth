Request = './request'

module.exports = ({make, Joi}) ->
  Tourist = make 'Tourist',
    schema:
      account:  String
      location: String
      request:  String
      notes:    String

  Object.assign Tourist::,
    placeRequest: (destination, time, guests) ->
      @request = (new Request {seats, time, destination}).id

    cancelRequest: ->
      if @request
        Request.find id: @request
          .cancel()
