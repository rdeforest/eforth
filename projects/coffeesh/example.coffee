#!/usr/bin/env cssh

lineCount = 0

module.exports =
  perLine:      (line)  -> console.log "#{lineCount++}: #{line}"
  withAllLines: (lines) -> console.log "Got #{lines.length} lines in all."
  withError:    (err)   -> console.log "Something went wrong?\n#{err}"
