ops =
  true:  (a, b) -> a + b
  false: (a, b) -> a * b

module.exports =
  arrayConversion = (array) ->
    add = true

    while array.length > 1
      newArray = (ops[add] a, b while ([a, b, array...] = array).length)
      array = newArray
      add = not add

    array[0]
