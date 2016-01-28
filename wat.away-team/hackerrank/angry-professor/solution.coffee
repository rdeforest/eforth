processData = (input) ->
  lines = input.split '\n'
  pullInts = -> lines.shift().split(' ').map (n) -> parseInt n

  [tests] = pullInts()
  while tests--
    [n, k] = pullInts()
    times = pullInts()
    process.stdout.write testClass n, k, times

testClass = (n, k, times) ->
  if times.filter
  while times.length
    n = times.pop()

    if n < 0
      return 'YES' unless --k > 0

  return 'NO' if k > 0


process.stdin.resume()
process.stdin.setEncoding 'ascii'
_input = ''
process.stdin
  .on 'data', (d) -> _input += d
  .on 'end', processData _input
