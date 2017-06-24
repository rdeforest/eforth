    module.exports = (opts) ->
      indentedJSON = (v) -> JSON.stringify v, 0, 2

      if false and opts.enhanceCoreClasses
        String.prototype.writeTo = (fileName) ->
          putText fileName, this

        Object.prototype.writeTo = (fileName) ->
          indentedJSON(this).writeTo (fileName)

      getText: (fileName)       -> (fs.readFileSync fileName).toString()
      putText: (fileName, text) -> fs.writeFileSync fileName, text

      getObj:  (fileName)       -> JSON.parse getText fileName
      putObj:  (fileName, obj)  -> putText fileName, indentedJSON obj

