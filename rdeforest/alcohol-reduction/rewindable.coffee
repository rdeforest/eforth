###


###

class Step
  constructor: (info) ->
    { @forward = (->)
      @reverse = (->)
      @desc
    } = info

  #throw new Error "Description is required" unless @desc

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

  constructor: (deps = {}) ->
    { @log = @log
    } = deps

    @steps = []

  addStep: (step) ->
    unless step instanceof Step
      step = new Step step
      
    @steps.push step
    @

  execute: ->
    @executeNextStep @steps
      .then =>
        @log "executeNextSteps finished without error"
      .catch (info) =>
        {step, err, completed} = info
        @startRollback step, err, completed

  executeNextStep: (steps, completed = []) ->
    return completed unless steps.length

    [step, pending...] = steps

    step
      .start()
      .then  (ret) =>
        completed.push {step, ret}

        @executeNextStep pending, completed
      .catch (err) =>
        throw {step, err, completed}

  startRollback: (step, err, completed) ->
    @log """
        Execution failed on step '#{step.desc}' after #{completed.length} successful steps.
        The failure reason was '#{err?.message? or err}'

        Starting rollback.
      """

    @rollback completed
      .catch (errors) => @finishRollback { errors }
      .then (results) => @finishRollback {        }

  rollback: (pending, rollbackErrors = []) ->
    return rollbackErrors unless pending.length

    [{step}, pending...] = pending

    step.rollback()
        .catch (err) => rollbackErrors.push err
        .then =>
          @rollback pending, rollbackErrors

  finishRollback: ({errors}) ->
    if errors
      errListStr =
        "with the following errors:\n  #{errListStr}" +
        errors.map ({err}) -> err
              .join "\n  "

      return @log "Rollback #{if aborted then "aborted" else "finished"} #{errListStr}"

    @log "Rollback finished without further errors."

Object.assign module.exports, {
    Step
    RewindableStepSequence
  }

