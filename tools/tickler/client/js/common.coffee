define [], ->
  Common =
    TodoFilter: ''

    ENTER_KEY: 13
    ESCAPE_KEY: 27

    apiUrl: '/api/v1'
    api: (parts...) ->
      [Common.apiUrl, parts...].join '/'

    updateAuthHeader: ->
      session = Common.session
      curHeaders = $.ajaxSetup().headers or {}

      if session
        curHeaders.Authorization = session.id
      else
        delete curHeaders.authorization

      $.ajaxSetup headers: curHeaders

  Object.defineProperty Common, 'session',
    get: -> JSON.parse localStorage.getItem 'sessionKey'
    set: (session) ->
      localStorage.setItem 'sessionKey', JSON.stringify session
      Common.updateAuthHeader()

  Common
