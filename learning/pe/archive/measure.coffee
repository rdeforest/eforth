last = null

process.stdin.on 'data', (data) ->
  s = data.toString()

  if last
    diff = (Date.now() - last).toString()
  else
    diff = 100000

  rate = diff / s.length


  console.log "#{diff} #{rate} ", s

  last = Date.now()
