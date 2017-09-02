R = require 'ramda'

matchDayOrTimeOrEvent = /// ^
    ( \w+ \d/\d .*)
  | ( \w+ \d\d:\d\d (?: am | pm ) )
  | ( .* :: .* )
///

matchDay   = /^\w+ \d\/(\d)/

matchTime  = /^(\w+) (\d\d:\d\d) (am|pm)/

matchEvent = /// ^
    (.*?)\s*          # title
    ::\s              # separator
    \[(.*)\]          # venue

    (\d\d?) :
    (?:  0  | (3) ) .
    (?:  a  | (p) )   # start time

    \s*-\s*

    (\d\d?) :
    (?:  0  | (3) ) .
    (?:  a  | (p) )   # start time
  ///

assembleTime = (hour, thirty, pm) ->
  2 * (parseInt(hour) + (pm and 12) or 0 + (thirty and 0.5) or 0)

addEvent = (acc, event) ->
  [prev..., last]            = acc
  {title, venue, start, end} = event
  (last[start] ?= {})[venue] = event
  acc

allVenues = new Set

eventId = 0

cell = (contents, width = 6, height = 3) ->
  [1..height].map (row) ->
    next = contents[from = row * width..from + width - 1]

    next[if row is 1 then 'padLeft' else 'padRight'] width, ' '

halfHourToTime = (hh) ->
  "#{(hh >> 1).toString().padStart 2, '0'}:#{if hh % 2 then "30" else "00" }"

starting = (event, width = 6, height = 3) ->
  start = halfHourToTime event.start
  cell start + "  " + event.title

continuing = (event) ->
  [ "|       "
    "|       "
    "|       "
    "|       "
  ]

ending = (event) ->
  end = halfHourToTime event.end

  [ "|       "
    "|       "
    "|       "
    "| #{end} " ]

dayTable = (startTimes) ->
  [from, middle..., to] = Object.keys(startTimes).sort()

  for time in [from .. to]
    venues = startTimes[time] or {}

    for venue from allVenues
      event = (startTime[time] ?= [])[venue]

      switch time
        when event.start then starting   event
        when event.end   then ending     event
        else                  continuing event

scheduleTable = (days) ->
  [fri, sat, sun, mon] = days.map dayTable
  columns = allVenues.size + 1
  [ cell(""), Array.from(allVenues).map columnHeadder
  ]

showSchedule = (dayTable) ->

fs.readFile 'schedule.orig', (buf, err) ->
  showSchedule dayTable buf
    .toString()
    .split /\n/g

    .map (line) ->
      if matched = line.match matchDayOrTimeOrEvent
        [whole, day, time, event] = matched
        if day
          return day: day.split(' ')[1][3]

        if time then return

        [     whole,       title, location
          startHour, startThirty,  startPM
            endHour,   endThirty,    endPM
        ] = event.match matchEvent

        start = assembleTime startHour, startThirty, startPM
        end   = assembleTime   endHour,   endThirty,   endPM

        allVenues.add venue

        event: { eventId: eventId++, title, venue, start, end }

    .filter (i) -> i

    .reduce ((acc, dateOrEvent) ->
        if dateOrEvent.day
          [acc..., []]
        else
          addEvent acc, dateOrEvent
      ), []

