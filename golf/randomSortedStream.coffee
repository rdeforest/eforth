n = 0
MAX = 100000000
{exit, argv} = (process = require 'process')
[c, s, interval = 1000] = argv

process.on 'SIGPIPE', exit
process.on 'SIGINT',  exit
process.on 'uncaughtException', exit

doAnother = ->
  try
    n += Math.floor 1 + Math.random() * 3
    exit() if n > MAX / 10
    console.log (MAX+n).toString()[1..]
  catch e
    exit()

setInterval doAnother, interval
