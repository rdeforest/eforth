# Explicit blocking vs implicit blocking

## Explicit

Explicit is what we have now:

    quoteMachine.any()
      .then (quote) ->
        console.log "Thus spake the quote machine: #{quote}"

## Implicit

Implicit means that async calls return promises which are evaluated lazily.
Expressions dependent on the resolution of promises themselves become
promises.

    quote = quoteMachine.any()

'quote' is now a promise

    console.log "Thus spake the quote machine: #{quote}"

This is secretly turned into

    quote.then (quote) ->
      console.log "Thus spake the quote machine: #{quote}"

## Lazy evaluation

Lazy evaluation is not currently an integral part of JavaScript or
CoffeeScript. To preserve the odering of operations implied by the procedural
code in blocks. Here's an example re-write:

Before:

    result = request lookupStuff

    if result.success
      db.commit result.txn
    else
      db.rollback result.txn

After:


...

# What if everything were a promise?

    lvalue = expr
    doMoreStuff lvalue
    andSomeMoreStuff()

becomes

    expr
      .then (result) -> lvalue = result; doMoreStuff lvalue
      .then (result) ->                  andSomeMoreStuff()


