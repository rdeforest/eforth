{ fs, path, assert, suite, process } = require '.'

intemp = tempdir = pending = null

maybeDoneMaker = (done, steps) ->
  pending = new Set steps

  (completed, next) -> (err) ->
    done err if err

    pending.delete completed

    next() if 'function' is typeof next

    if pending and pending.size is 0
      pending = null
      done()

before = (done) ->
  fs.mkdtemp 'find-', (err, folder) ->
    done err if err

    process.chdir tempdir = folder

    intemp = (parts...) -> path.resolve '.', parts...

    maybeDone = maybeDoneMaker done, [ 'aDir', 'file1', 'file2', 'deepFile1', 'deepFile2' ]

    fs.writeFile intemp('file1'), '', maybeDone 'file1'
    fs.writeFile intemp('file2'), '', maybeDone 'file2'

    fs.mkdir intemp('aDir'), maybeDone 'aDir', ->
      fs.writeFile intemp('aDir', 'deepFile1'), '', maybeDone 'deepFile1'
      fs.writeFile intemp('aDir', 'deepFile2'), '', maybeDone 'deepFile2'

after = (done) ->
  maybeDone = maybeDoneMaker done, [ 'tmpdir', 'aDir', 'file1', 'file2', 'deepFile1', 'deepFile2' ]

  fs          .unlink intemp('file1'), maybeDone 'file1', ->
    fs        .unlink intemp('file2'), maybeDone 'file2', ->
      fs      .unlink intemp('aDir', 'deepFile1'), maybeDone 'deepFile1', ->
        fs    .unlink intemp('aDir', 'deepFile2'), maybeDone 'deepFile2', ->
          fs  .rmdir  intemp('aDir'), maybeDone 'aDir', ->
            process.chdir '..'
            fs.rmdir  intemp(), maybeDone 'tmpdir'

suite 'find callback, options', {before, after}, (suite, test) ->
  { find } = require '../lib/find'

  test 'invokes a callback for entries it finds', (done) ->
    calls = 0

    callback = ->
      calls++
      done() unless calls > 1

    find callback

  test 'callback receives fullPath', (done) ->
    calls = 0

    callback = (received) ->
      assert.equal 'string', typeof received.fullPath
      done() if not calls++

    find callback

  test 'optional predicate filters entries', (done) ->
    skipped = null

    calls = 0

    predicate = (received) ->
      if not skipped
        skipped = received
        false
      else
        true

    callback = (received) ->
      if skipped is received
        done new Error 'Receiver called with skipped entry'

      else if not skipped
        done new Error 'Receiver called before predicate'

      done() if not calls++

    find callback, { predicate }

  # Need to make this optional because achieving it requires anti-async
  # shenanigans.
  false and test 'recursion is depth first', (done) ->
    aDir = false
    deep = false
    calls = 0

    callback = ({fileName}) ->
      console.log "SAW: #{fileName}"

      if aDir or= (fileName is 'aDir')
        done new Error 'saw aDir before a deep file'

      if deep or= (fileName.startsWith 'deep')
        done() if calls++

    find callback

  test '.next option invoked after all async tasks finish', (done) ->
    find (->), next: done

  false and test 'optional recursion predicate controls recursion', (done) ->
    noRecurse = (received) -> false

    seen   = 0
    reseen = null

    examineSeen = ->

    callback = ({fileName}) ->
      if reseen
        reseen.push fileName
      else
        seen.push fileName

    find callback, {recurse}
