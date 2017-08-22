module.exports = (logger = require '../index') ->
  {entries, q, year, month, day, start, stop} = logger

  entries year 2016,
    month 4,
      day 20,
        start '16:25', 'demonstrating this format'
        start '16:26', q.example = example: 'how to use the q object'
        stop '16:27'

