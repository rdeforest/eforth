###

Current effort: simplify by removing "rollbackErrorIsFatal" and "rollbackOnOwnError"

The contract for a Step is that when it fails, it has already cleaned up after
itself, and when it can't clean up other steps still get a chance to try to
clean up.

Or to put it another way: 

- failure of a step indicates it made no changes.
- failure to roll back is meaningless.

###

class Step
  constructor: (info) ->
    { @forward = ->
      @reverse = ->
      @desc    = @forward.name
    } = info

  start    : -> Promise.resolve @forward()
  rollback : -> Promise.resolve @reverse()

class RewindableStepSequence
  @comment: """
    I call a series of functions. When one fails I call the associated series
    of rollback functions. If one of those fails I optionally abort the
    rollback.

    Example usage:

        new RewindableStepSequence
          .addStep
            desc: "beginning"
            forward: -> "It has begun"
            reverse: -> "It never happened"
          .addStep
            desc: "a step which aborts rollback"
            reverse: -> throw new Error "couldn't undo the nothing we didn't do"
            rollbackErrorIsFatal: true
          .addStep
            desc: "a step which fails but also rolls itself back"
            forward: -> throw new Error "oops"
            reverse: -> throw "no side effects need to be reversed"
            rollbackOnOwnError: true
          .addStep desc: "Is that all?"
          .execute()

    Likely output:

        Step 'beginning': It has begun
        Execution of 3rd step 'a step which fails' failed because of 'oops'.
        Starting rollback.
        Rollback aborted with 1 step left to roll back, and the following errors:
          'a step which fails but also rolls itself back': no side effects need to be reversed
          'a step which aborts rollback': couldn't undo the nothing we didn't do

    Or if the third step didn't fail:
        Step 'beginning': It has begun
        Step 'Is that all': undefined
  """

  constructor: -> @steps = []

  addStep: (step) ->
    unless step instanceof Step
      step = new Step step
      
    @steps.push step
    @

  execute: (steps = @steps, completed = []) ->
    [step, pending...] = steps

    step.start()
      .catch (err) => @startRollback step, err, completed
      .then  (ret) =>
        completed.push {step, ret}

        if pending.length
          return @execute pending, completed

        completed

  startRollback: (step, err, completed) ->
    console.log """
        Execution failed on step '#{step.desc}' after #{completed.length} successful steps.
        The failure reason was '#{err?.message? or err}'

        Starting rollback.
      """

    @rollback completed
      .catch (errors) => @finishRollback { errors }
      .then (results) => @finishRollback {        }

  rollback: (pending, rollbackErrors = []) ->
    [step, pending...] = pending

    step.rollback()
        .catch (err) => rollbackErrors.push err
        .then =>
          if pending.length > 0
            @rollback pending, rollbackErrors
          else
            rollbackErrors

  finishRollback: ({errors}) ->
    if errors
      errListStr =
        "with the following errors:\n  #{errListStr}" +
        errors.map ({err}) -> err
              .join "\n  "

      return console.log "Rollback #{if aborted then "aborted" else "finished"} #{errListStr}"

    console.log "Rollback finished without further errors."

Object.assign module.exports, {
    Step
    RewindableStepSequence
  }

