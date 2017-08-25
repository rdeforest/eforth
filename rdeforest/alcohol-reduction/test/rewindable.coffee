{ RewindableStepSequence } = require '../rewindable'
assert = require 'assert'

module.exports =
  rewindable:
    "should execute a sequence of steps": ->
      first = middle = last = false

      (seq = new RewindableStepSequence)
        .addStep
          desc: "first step"
          forward: -> first = true
        .addStep
          desc: "middle step"
          forward: -> middle = true
        .addStep
          desc: "last step"
          forward: -> last = true
        .execute()
        .then ->
          assert first and middle and last
    "should roll back on error": ->
      first = middle = last = false
      firstRewound = mildleRewound = lastRewound = false

      (seq = new RewindableStepSequence)
        .addStep
          desc: "first step"
          forward: -> first = true
          rewind: -> firstRewound = true
        .addStep
          desc: "middle step"
          forward: -> middle = true; throw "error"
          rewind: -> middleRewound = true
        .addStep
          desc: "last step"
          forward: -> last = true
          rewind: -> lastRewound = true
        .execute()
        .catch ->
          assert first and middle and not last, "stops at middle"
          assert firstRewound, "rewinds first"
          assert not (middleRewound or lastRewound), "doesn't rewind 2nd and 3rd"

