Note:

  - 'Contact' portion of this project overlaps with TIC project

Pending:

  - Convert everything I care about to CoffeeScript
    - One of
      - get require-cs working
      - set up auto-compilation

  - UI
    - User sign-up
    - User login
    - Item management
      - mostly done because STOLEN :)
    - Schedule management
      - can probably copy item stuff
    - Pop-ups for reminders

  - fixup
    - Make CoffeeScript compilation an automatic part of startup

  - Correct ACLs
    - https://docs.strongloop.com/display/public/LB/Accessing+related+models

  - Tests!

Doing:

  - Todos to Items
    - Started 12:40
    - Noted time at 13:35, taking break
    - Restart at 13:40
    - Then sun came out and was super annoying at 13:50
    - Then figured out sessions still aren't quite right
    - Doing SESSIONS now (14:00)
    - Getting super frustrated
    - Giving up at 14:15
    - Moved to Stumptown
      - trying to make most of 20 minutes remaining before karaoke
      - it's 14:30
      - Then went to karaoke at 14:50
    - Then resumed around 20:00
      - overrode Backbone.ajax to insert session id header
      - Looks like it works, committing changes
    - Then finished the next day?!

Done:

  - UI: Register + Login
    - After registering user, log them in
    - Update form (hide fields, change buttons etc)
    - Started at 12:00
    - Got login success at 12:30
    - And logout success at 12:55
  - UI: Register
    - Click Register with login, pass and confirm filled in creates account
    - started at 10:40
    - Got side-tracked into CoffeeScript crap, re-started at 10:55
    - Successfully created account at 12:00
  - Reproduce work from 2016-03-05 instead of walking home and checking it in
    - started at 09:30
    - finished at 10:30
  - Expose remote methods
    - Have to compile CoffeeScript
  - Figure out authenticated testing
  - Moved to sqlite persistence
  - Does model.coffee replace model.js?
    - YES!
  - participant.pendingMessages()
    - Does participant.items() do what I think?
      - Apparenly, but need to create an example item to be sure
      - Easier said than done, but whatever.
    - make item.due() and .acknowledge work
    - make pendingMessages work


