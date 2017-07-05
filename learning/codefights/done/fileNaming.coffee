module.exports =
  fileNaming = (names) ->
    used = {}

    for name, idx in names
      if name in Object.keys used
        k = 1

        while used[ newName = name + "(#{k})" ]
          k++

        name = newName

      used[name] = 1

      console.log used

      name

