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

  - UI: Register + Login
    - After registering user, log them in
    - Update form (hide fields, change buttons etc)
    - Started at 12:00
    - Got login success at 12:30

Done:
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


