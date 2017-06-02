module.exports =
  reflectString = (str) ->
    zee = 'z'.charCodeAt(0) + 'a'.charCodeAt(0)

    codes = str
      .split ''
      .map (c) -> String.fromCharCode zee - c.charCodeAt 0
      .join ''


