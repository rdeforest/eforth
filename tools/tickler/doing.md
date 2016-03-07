# Doing

  - Finish Schedule UI
    - Make editing work

# v0.1

## Pending

  - UI
    - Schedule management
      - Associate items with schedules
      - Accept and interpret english time intervals like "1 hour"
      - Make schedule times display well
    - Pop-ups for reminders

  - fixup
    - Make CoffeeScript compilation an automatic part of startup
    - Tests!
    - Correct ACLs
      - https://docs.strongloop.com/display/public/LB/Accessing+related+models

## Done

  - Switched item view to a table. OH NOES! :P
  - Restore editing CSS stuff
  - Broke out tabs into their own views
  - Changed all the 'todo' references to 'item'
  - Separated CoffeeScript from JavaScript
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


# v0.2

  - Re-implement "from scratch" without cribbing from TodoMVC

# v0.X

  - instant messaging reminders
  - email
  - integrate w/ Trello

