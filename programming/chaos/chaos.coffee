###

Implement the old Chaos interpreter on top of JavaScript.

Chaos:

  * RPN
  * 'blarg == "blarg"     // 'symbols' - currently just strings
  * "blarg" == "blarg"    // string literal
  * [] for list literals
  * { code } or { args | code } for block literals
  * value of a block is its last expression (hello coffeescript...)
  * primitives
    * value 'varName set  // varName = value
    * 'block loop         // while (block) {}
    * member obj .        // obj[member]
    * 'member obj .       // obj.member
    * 'block do           // block(...)       ... depends on args of block

Examples:

    { "hello world" 'log console . } 'hello set
    hello

###

class ChaosParser
  constructor: (@stream, @receiver) ->
    @buffer = ''

    stream.on 'data', (d) ->
      @buffer = @buffer + d
      @tokenizer()

  pullToken: ->
    if @buffer[0] == '\''
      return @pullSymbol()

    if '0' <= @buffer[0] and @buffer[0] <= '9'
      return @pullNumber()

  tokenizer: ->
    nextToken = undefined

    while nextToken = @pullToken()
      @receiver nextToken
