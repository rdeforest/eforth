# The what...

  - notification "hey, listen!"

# User stories

  - create user
  - create tickle item entry
  - create interval
  - assign interval
  - start entry
  - stop entry

# Design

## API

The usual REST stuff applies

  - /users
  - /items
  - /intervals
  - /schedules

Also

  - /users/:id/pendingMessages

## Models

- User
  - auth info
  - hasMany
    - items
    - schedules
- Item
  - someText
- Interval
  - 
- Schedule
  - boolean running
  - last fired
  - belongsTo interval
  - belongsTo item

# backlogged items

## feature

- gathering responses to tickles
- client more sophisticated than a regular web page with javascript
