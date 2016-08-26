Simplifying iteration

    if false
      for idx, el of fn()
        console.log "#{idx}: #{el}"

      for el, idx in fn()
        console.log "#{idx}: #{el}"

We want this to work even if fn() returns an Iterable. Currently the above
translate to

var el, i, idx, len, ref;

ref = fn();
for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
  el = ref[idx];
  console.log(idx + ":" + el);
}

We need it to look more like...

      _iter = _util.makeIterator fn()

      while not ({value} = _iter.next()).done
        [idx, el] = value
        console.log "#{idx}: #{el}"

And the complexity goes in \_util.makeIterator

    module.exports = _util =
      _util:
        makeIterator: (subject) ->
          isIterable = 'function' is typeof subject[Symbol.iterator]

          ( switch
              when isIterable                 then @wrapIterable
              when Array.isArray      subject then @makeArrIter
              when 'string' is typeof subject then @makeArrIter
              when 'object' is typeof subject then @makeObjIter
              else @nullIter
          ) subject

        nullIter: (subject) ->
          (->
            if true
              return

            yield undefined # unreachable, but that's what it takes
          )()

        makeObjIter: (subject) ->
          (->
            for key, val of subject
              yield [key, val]
          )()

        makeArrIter: (subject) ->
          (->
            for val, key in subject
              yield [key, val]
          )()

        wrapIterable: (subject) ->
          iter = subject[Symbol.iterator]()

          (->
            idx = 0

            while ({value, done} = iter.next()).done is false
              yield [idx++, value]
          )()

