assert = require 'assert'
fs     = require 'fs'
path   = require 'path'

module.exports.find =
find = (info, moreInfo = {}) ->
  if 'function' is typeof info
    moreInfo.receiver = info
    info = moreInfo

  { from  = '.'  , recurse = (-> true), predicate = (-> true)
    lstat = false, next    = (->)     , receiver
  } = info

  assert 'function' is typeof receiver

  stat = (fullPath) ->
    lstat = null

    (s = fs.stat fullPath)
      .isSymbolicLink = ->
        (lstat or= fs.lstat fullPath).isSymbolicLink()

    s

  _find { from, recurse, predicate
          stat, next, receiver}

_find = (info) ->
  { from, recurse, predicate, next
    stat, receiver, seen = new Set} = info

  fs.readdir from, (err, entries) ->
    entries.map (entry) ->
      pending = 0

      if seen.has fullPath = path.resolve relativePath = path.join from, entry
        return

      seen.add fullPath

      s = stat fullPath

      entry = {fileName: entry, fullPath, relativePath, stat: s}

      if s.isDirectory() and recurse entry
        pending++

        _find Object.assign {}, info, from: relativePath, {entry}, next: ->
          if predicate entry
            receiver entry

          pending--

          next() if not pending
