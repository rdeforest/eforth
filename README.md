# rdeforest

Self-management project

# Customer: me!

## Opportunities

Improve recurring tasks in some way

  - Tasks
    - self
      - existence: breathe, sleep, drink, eat
      - therapy/recovery/health/...
        - medication
        - therapy homework
      - maintenance
        - bathing
        - clothing
        - poopin?
        - brushing, flossing
      - improvement
        - exercise
        - journaling
        - practice
          - guitar
        - research
        - projects
          - music
          - programming
      - entertainment
        - RSS feeds
        - computer games
        - tabletop games
    - marriage
    - friends
    - work
    - family
  - Improvements
    - Executed more consistently (or at all in some cases)
      - That thing HabitRPG used to almost do for me
    - Resources (external, internal) devoted to said tasks reduced
      - Maybe find ways to make the tasks more efficient to execute?
    - Measured, monitored, alerting on threshold breech
      - The hardest but also most valuable improvement

# Minimum Viable Product ideas

## HabitRPG knock-off

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

### Models

  - Program
    - Project
      - Process
        - Task
        - Schedule
          - Period designation (work m-f, 08:00-12:00, 13:00-17:00)
        - Interval
        - CalculatedTime

# Todo

Move small-projects/notes/{personal,work,whatever} under this project?
