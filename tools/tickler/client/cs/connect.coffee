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

    buttonStates =
      connected:    logout:   'enable'
      confirmed:    register: 'enable'
      emptyConfirm: login:    'enable'

    updateButtons = (status) ->
      buttons =
        login: 'disable'
        logout: 'disable'
        register: 'disable'
      _.extend buttons, buttonStates[status]

      for button, state of buttons
        $("##{button}").button state

    validateSession = (session) ->
      if session
        $.ajax
            type: "GET"
            url: Common.api 'Participants', session.userId
            headers: Authorization: session.id
          .done (user, result, response) ->
            for field in ['goal', 'username', 'email']
              $("#" + field).val user[field]

            updateButtons 'connected'

            session.user = user
            Common.session = session

          .fail (error) ->
            $("#todoapp").tabs active: 2

            Common.session = null

    logoutUser = ->
      $.post Common.api 'Participants', 'logout'
        .done (o, result, response) ->
          updateButtons()

    loginUser = (user = fields 'username', 'password') ->
      $.post data: user, url: Common.api 'Participants', 'login'
        .done (session, result, response) ->
          if result is "success"
            Common.session = session
            updateButtons 'connected'
        .fail ->
          console.log "todo: login failure UI effect"

    registerUser = ->
      form = fields 'goal', 'username', 'password', 'email'

      $.post data: form, url: Common.api 'Participants'
        .done (user, result, response) ->
          if result is "success"
            {username, password} = form
            loginUser {username, password}
        .fail (error) ->
          console.log "Register failed: ", arguments

    init: ->
      $("#logout")
        .button()
        .click (e) ->
          logoutUser()

      $("#login")
        .button()
        .click (e) ->
          loginUser()

      $("#register")
        .button()
        .click (e) ->
          registerUser()

      $("#passconf #password")
        .keyup (e) ->
          pass = $("#password").val()
          conf = $("#passconf").val()

          updateButtons ''

          if pass
            if not conf
              updateButtons 'emptyConfirm'
            else if pass is conf
              updateButtons 'confirmed'

      validateSession Common.session

