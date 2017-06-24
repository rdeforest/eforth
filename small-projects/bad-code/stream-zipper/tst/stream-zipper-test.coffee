Zipper = require 'stream-zipper'
stream = require 'stream'
assert = require 'assert'

TestStream = (items) -> new stream.Readable
  objectMode: true
  read: -> @push items.shift()

a = new TestStream "one two three".split ' '
b = new TestStream [1..3]

resultsStream =
  new Zipper {}, a, b
    .pipe new stream.Transform {
        decodeStrings: false
        objectMode: true
        transform: ([a, b], ignored, callback) ->
          r = "#{a}: #{b}"
          console.log "got: #{r}"
          @push r
          callback null
      }

assert.equal resultsStream.read(), "one: 1"
assert.equal resultsStream.read(), "two: 2"
assert.equal resultsStream.read(), "three: 3"
