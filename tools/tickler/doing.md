Note:

  - 'Contact' portion of this project overlaps with TIC project

Stack:

  - this tickler stuff
  - Nicole's email thingie

Pending:

  - UI
    - User sign-up
    - Item management
    - Schedule management
    - Pop-ups for reminders

  - fixup
    - Make CoffeeScript compilation an automatic part of startup

  - Correct ACLs
    - https://docs.strongloop.com/display/public/LB/Accessing+related+models

Doing:

  - UI
    - User creation form

Done:
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


