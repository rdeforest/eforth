listToObject = (entries) -> Object.assign {}, entries...

defaultCode = ((args...) -> {this: @, args}).toString()

functionRegexp = ///
    ^ function \s*
    \( \s* ([^)])* \) \s*  # args
    { \s* (.*) }           # body
  ///

extractFunctionDefinition = (fn) ->
  code =
    if 'function' is typeof fn
      code = fn.toString()
    else
      defaultCode

  matched = code.match functionRegexp

  unless matched
    throw new Error "code.toString() didn't match the function pattern. Value was:\n#{code}"

  [theWholeString, argStr, body] = matched

  argNames =
    argStr
      .split /\s*/
      .map (argName) -> argName.trim()

readOnly = (obj, nameOrSymbol, value) ->
  Object.defineProperty obj, nameOrSymbol, get: -> value

virtualFns = (obj, nameAndExample) ->
  if @ instanceof obj
    sep = "::"
  else
    sep = "."

  for name, example of nameAndExample
    args = (extractFunctionDefinition example).join ", "
    emsg = "Virtual function #{sep}#{name}(#{args}) not implemented on #{@constructor}"

    obj[name] = -> throw new Error emsg

Object.assign exports, {
  listToObject, defaultCode
  functionRegexp, readOnly
  extractFunctionDefinition
  virtualFns
}
