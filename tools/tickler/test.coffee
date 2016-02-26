request = require 'request'

api = 'http://localhost:3000/api/v1'
api.user = api + "/Participants"
api.login = api.user + '/login'

user =
  username: 'testing'
  password: 'testing'
  email: 'testing@defore.st'
  goal: 'test this stuff'

create = (api, user) ->
  new Promise (resolve, reject) ->
    request
      .post api.user, user, (err, resp, body) ->
        if err
          reject err
        else
          resolve {resp, body}

login = (api, user) ->
  new Promise (resolve, reject) ->
    request
      .post api.login, user, (err, resp, body) ->
        if err
          reject err
        else
          resolve {resp, body}
        
