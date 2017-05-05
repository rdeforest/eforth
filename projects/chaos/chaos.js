/*

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

*/

var ChaosParser = function (stream, receiver) {
  this.buffer = '';
  this.stream = stream;
  this.receiver = receiver;

  stream.on('data', function (d) {
    this.buffer = this.buffer + d;
    this.tokenizer();
  });
}

ChaosParser.prototype = {
  pullToken: function () {
    if (this.buffer[0] === "'") return this.pullSymbol();
    if ("0" <= this.buffer[0] &&  this.buffer[0] <= "9") return this.pullNumber();
  },

  tokenizer: function () {
    var nextToken;

    while (nextToken = this.pullToken()) {
      this.receiver(nextToken);
    }
  },
};
