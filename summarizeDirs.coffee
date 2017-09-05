# Given a list of paths, list only the leaves

process = require 'process'

YAML = require 'js-yaml'

buf = Buffer.from ''

ownChildren = (lines, i) ->
  children =
    for [line, prefixIndex], childIdx of lines[i + 1..]
      if prefixIndex > i
        break

  [lines[i], i - childIdx - 1, children]

gather = (instream) ->
  new Promise (resolve, reject) ->
    buf = Buffer.from ''

    instream
      .on 'data', (data) -> data = Buffer.concat data, buf
      .on 'end', -> resolve buf.toString()
      .on 'error', (e) -> reject e

processLines = (lines) ->
  children = []
  reversed = []

  for line, lidx in lines
    parents.push []
    nearestParentIdx = (l) ->
      ridx = reversed.findIndex (prefix) -> l.startsWith prefix

      if ridx isnt -1
        idx = reversed.length - ridx
        children[idx].push lidx

    reversed.unshift line

