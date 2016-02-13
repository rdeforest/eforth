# HabitRPG knock-off

  - Should integrate with real HabitRPG to the degree that that is possible
    and makes sense.

  - Arbitrary scheduling
    - cron style
    - "at least twice a week"
    - "no more than twice in 48 hours"
    - "every Monday"
    - "second to last Thursday of every month"
    - "month.days/2" = 14th in February, 15th every other month
    - will probably need a DSL for this

  - day planning w/ optional automation

  - "do one thing"
    - Means of querying one thing that needs to be done
    - Unable to view other things without a reason why that can't be done right now

  - mobile interface

# MVP

## possible features

  - products
    - tickler
      - notifications
      - checklists
      - check-ins
    - work inventory
    - scheduler (mapping tasks to times)
      - spanner
      - repeater
      - designations/allocations
    - journal
      - manual notes
      - activity log (task progress, etc)
    - Project Management
      - customers, products, programs, projects, goals, ...

  - features
    - annotation of anything
    - dependencies, conflicts
    - measurement, alerting
    - priorities, deadlines
      - need to clarify 
        - "priority": calculated by a scheduling module
        - "urgency": cost of a miss
        - "importance": value of a hit
      - A scheduler determines priority of items in a given queue
      - A deadline is an aspect (milestone) of urgency/importance functions
        - There can be "reverse" deadlines: don't start before X time
        - "Deadline" is a kind of dependency
    - interoperability
      - API
      - many formats undertood: CSV, JSON, YAML, XML, etc
    - scriptable
      - templates for objects
      - hooks for events
      - support as many languages as possible

  - Specific use cases
    - kitty litter recurring task
      - half-measure
        - Covering existing litter delays the innevitable
      - parameters
        - temporal
          - at least 60 hours between completion and starting
          - urgency increases by the half day
        - staff: who can/usually does it
        - steps
          - branch 1: partial
            - result: litter stops stinking for a little while
            - method: throw 5lb of litter on existing litter
            - requires: less than 15lb (dry) litter already in box
          - branch 2: regular cycle
            - result: litter stops stinking for a good while
            - method:
              - empty litter box into garbage via bucket loads
              - place 5lb dry litter in box
          - branch 3: full
            - result: stink put off even longer
            - method:
              - empty box
              - rinse box
              - refill
    - task management
      - pre-dependencies determine priority and visibility


  - Task patterns
    - done or not (simple check)
    - multiple sub steps which can be completed at different times
    - granular tasks which can be done part way
      - differs from steps in that it changes the prioritization
    - branching
    - different was of measuring progress: steps vs time spent vs ...
    - optional sub-steps

# Apps relevant to our interests

  - llama : location triggered tickler
  - tasker: cell phone cron and more
  - ifttt : internet message disbatch
  - google apps? gears? some kind of scripting thing
  - AWS lambda

# Later version ...

## Models

  - Program
    - Project
      - Process
        - Task
        - Schedule
          - Period designation (work m-f, 08:00-12:00, 13:00-17:00)
        - Interval
        - CalculatedTime

