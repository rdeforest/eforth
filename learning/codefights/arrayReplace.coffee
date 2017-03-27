arrayReplace = (inputArray, elemToReplace, substitutionElem) ->
  inputArray.map (n) -> if n is elemToReplace then substitutionElem else n

(require './genericTester') [
], arrayReplace
