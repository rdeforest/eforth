# The what...

  - notification "hey, listen!"

# User stories

  - create user
  - create tickle item entry
  - create schedule
  - assign schedule
  - start entry
  - stop entry

# Design

## API

The usual REST stuff applies

  - /users
  - /items
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
- Schedule
  - boolean running
  - number secondsBetweenTickles
  - number lastFired
  - belongsTo item
  - belongsTo user

# StrongLoop setup

    slc loopback tickler
    cd Tickler

    slc loopback:model Participant
    # extends User because Loopback requires it
    # goal as string

    slc loopback:model Item
    # contents as string

    slc loopback:model Schedule
    # nextEvent as number
    # interval as number

# backlogged items

## feature

- gathering responses to tickles
- client more sophisticated than a regular web page with javascript
