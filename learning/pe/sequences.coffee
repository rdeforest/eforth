# Collection of sequence generators

sequence = (generator) ->
  seq = []

  ->
    i = 0
    gen = generator()

    loop
      if i >= seq.length
        yield seq[i++] = gen.next().value
      else
        yield seq[i++]

    return

module.exports =
  squares: squares = sequence ->
    n = 1

    loop
      yield (n++) ** 2

    return

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

  fibonacci: fib = sequence ->
    [a, b] = [0, 1]

    loop
      [a, b] = [b, a + b]
      
      yield a

    return
