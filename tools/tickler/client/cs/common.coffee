define ['jquery'], ($) ->
  Common =
    ENTER_KEY: 13
    ESCAPE_KEY: 27

    apiUrl: '/api/v1'
    api: (parts...) ->
      [Common.apiUrl, parts...].join '/'

  Object.defineProperty Common, 'session',
    get: -> JSON.parse localStorage.getItem 'sessionKey'
    set: (session) ->
      localStorage.setItem 'sessionKey', JSON.stringify session

  Common
