Object.assign module.exports, {
    Step
    RewindableProcess
  }

class Step
  constructor: (info) ->
    { @desc
      @forward              = ->
      @reverse              = ->
      @rollbackOnOwnError   = false
      @rollbackErrorIsFatal = false
    } = info

    @desc ?= @forward.name ? @forward.toString()

  start: ->
    new Promise (resolve, reject) ->
      resolve step.forward()

class RewindableProcess
  constructor: -> @steps = []

  addStep: (step) -> @steps.push step

  execute: (steps = @steps, completed = []) ->
    new Promise (resolve, reject) ->
      step = steps.pop()

      try
        @startStep step, pending, completed
      catch err
        @startRollback err

  startStep: (step, pending, completed) ->
    step.start()
      result.catch (err) => @startRollback step, err,          completed
      result.then  (ret) => @completeStep  step, ret, pending, completed

  completeStep: (step, ret, pending, completed) ->
    completed.push {step, ret}

    @execute pending, completed

  startRollback: (step, err, completed) ->
    @log """
        execute of #{@nth completed.length + 1} step #{step.desc} failed because of
          #{err?.message? or err}

        Starting rollback.
      """

    if step.rollbackOnOwnError
      @rollback completed.concat(step)
    else
      @rollback completed

  rollback: (pending, rollbackErrors = []) ->
    if pending.length is 0
      throw "Rollback finished " +
        if rollbackErrors.length is 0
          "without further errors."
        else
          throw "with the following errors:\n  " + rollbackErrors.join("\n  ") + "\n"

    new Promise (resolve, reject) ->
      [step, pending...] = pending

      try
        @rollbackStep step, pending, rollbackErrors
          .catch (err) =>
          .then  (ret) =>



