Lookout MySQL manager

  - used for
    - alarms
      - low subset
      - customer metrics
    - table create and drop
      - Cleans up old tables
      - Creates new tables
        - Per-day
        - Tables name composed of metric and date

# Low subset alarm

No data from a (Device, POP, DC, Region) for a configured amount of time.

  - (Does it note partial data?)
  - Looks to see if ANY data has been received for a given subset in the last
    20 minutes.
    - If not, post an event to NOM
    - NOM events are suppressed by NARGs
    - If source of data isn't a network device, event goes to Remedy (sev2)
  - 

