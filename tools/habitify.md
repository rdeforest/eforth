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

## Models

  - Program
    - Project
      - Process
        - Task
        - Schedule
          - Period designation (work m-f, 08:00-12:00, 13:00-17:00)
        - Interval
        - CalculatedTime


# Apps relevant to our interests

  - llama : location triggered tickler
  - tasker: cell phone cron and more
  - ifttt : internet message disbatch
  - google apps? gears? some kind of scripting thing
  - AWS lambda
