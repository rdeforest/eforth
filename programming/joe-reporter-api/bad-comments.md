# Obvious

Most recently I noticed what I would consider "puffery": comments whose
messages are obvious to anyone with at least 2 years of experience:

    methodName: (args...) ->
      statements

      # Chain
      return @

That 'Chain' comment is entirely unnecessary. Anybody who is unfamiliar with
the chaining pattern is not likely to be upset by not knowing why one would
want to return 'this'.

Or even better:

    # Has Reportes
    # Do we have any reporters yet?
    hasReporters () {
      return libraryPrivate.reporters !== 0
    }

(The typo in the comment ('Reportes') is in the original source.)

This example is doubly offensive because it relies on ECMAScript type coercian
rather than explicitly testing reporters.length. I would have written this as

    hasReporters () {} return libraryPrivate.reporters.length

Yes, I'm relying on coercian from number to boolean, but that's natural,
probably.


