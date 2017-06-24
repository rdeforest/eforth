module.exports =
  decipher = (cipherText) ->
    (while cipherText
      codeLen = 1

      if cipherText[0] is '1'
        codeLen++

      code = cipherText[0..codeLen]
      cipherText = cipherText[codeLen + 1..]

      String.fromCharCode code
    ).join ''



