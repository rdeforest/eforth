# Wire up the Connect tab for registration and login
define [
    'jquery'
    'common'
    'jquery-ui'
  ], ($, Common) ->

    fields = (keys...) ->
      ret = {}

      for key in keys
        el = $("##{key}")[0]
        ret[el.id] = el.value

      ret

    validateSession = (session) ->
      $.ajax
          type: "GET"
          url: Common.api 'Participants', session.userId
          headers: Authorization: session.id
        .done (user, result, response) ->
          console.log "Validate result: ", arguments

          for field in ['goal', 'username', 'email']
            $("#" + field).val user[field]

          $("#logout").button 'enable'

    logoutUser = ->
      $.ajax
          type: "POST"
          url: Common.api 'Participants', 'logout'
          headers: Authorization: Common.session.id
        .done (o, result, response) ->
          console.log "Logout result: ", arguments

    loginUser = (user = fields 'username', 'password') ->
      url = Common.api 'Participants', 'login'

      $.ajax
          type: "POST"
          url: url
          data: user
        .done (session, result, response) ->
          console.log "Login result: ", arguments

          if result is "success"
            Common.session = session
            $("#logout").button 'enable'
            $("#login, #register").button 'disable'

    registerUser = ->
      url = Common.api 'Participants'
      form = fields 'goal', 'username', 'password', 'email'

      $.ajax
          type: "POST"
          url: url
          data: form
        .done (user, result, response) ->
          console.log "Register result: ", arguments

          if result is "success"
            {username, password} = form
            loginUser {username, password}

    $("#logout")
      .button()
      .button 'disable'
      .click (e) ->
        e.preventDefault() # XXX: Is this needed?

        logoutUser()

    $("#login")
      .button()
      .click (e) ->
        e.preventDefault() # XXX: Is this needed?

        loginUser()

    $("#passconf")
      .keyup (e) ->
        if @value isnt $("#password")[0].value
          $("#register").button 'disable'
        else
          $("#register").button 'enable'

    $("#register")
      .button()

      .click (e) ->
        e.preventDefault() # XXX: Is this needed?

        registerUser()

    validateSession Common.session

