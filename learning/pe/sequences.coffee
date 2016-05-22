# Collection of sequence generators

module.exports =
  even: even = ->
    n = 0

    loop
      yield n += 2

    return

  odd: odd = ->
    e = even()

    loop
      yield e.next().value - 1

    return

  fibonacci: fib = ->
    [a, b] = [0, 1]

    loop
      [a, b] = [b, a + b]
      
      yield a

    return
