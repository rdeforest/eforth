{ Step, RewindableStepSequence } = require '../rewindable'

assert = require 'assert'

makeTest = (len, failAt) ->
  forward = []
  back    = []

  addStep = (seq, n, fails) ->
    seq.addStep
      desc: "step #{n}"
      forward: ->
        forward[n] = true
        throw "error #{n}" if fails
      reverse: ->
        back[n] = true

  seq = new RewindableStepSequence log: ->

  for step in [1..len]
    addStep seq, step, failAt is step

  {forward, back, seq}

module.exports =
  Step:
    "should have a description": ->
      step = new Step desc: "test"
      assert step.desc is "test"

  Rewindable:
    "should execute a sequence of steps": ->
      {forward, back, seq} = makeTest 3

      seq
        .execute()
        .then ->
          fwd = forward.reduce (a, b) -> a and b
          assert fwd,             "all steps rolled orward"
          assert back.length is 0, "no steps rolled back"
    
    "should roll back on error": ->
      {forward, back, seq} = makeTest 3, 2

      seq
        .execute()
        .catch ->
          assert     forward[2], "second step attempted"
          assert not forward[3], "stopped at failure"
          assert     back[1]   , "rollback completed"
          assert not back[2] and
                 not back[3]   , "incomplete steps not rolled back"

