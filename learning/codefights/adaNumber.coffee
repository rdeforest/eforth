# https://codefights.com/arcade/code-arcade/well-of-integration/Ghe6HWhFft8h6fR49

module.exports =
  adaNumber = (line) ->
    line = line.replace /_/g, ""

    return true if line.match /^[0-9]+$/

    ALL_DIGITS = '0123456789abcdefghijklmnopqrstuvwxyz'

    numberPattern =
      /// ^(?: (\d|1[0-6])     \#
               ([0-9a-zA-Z]+) \#
          )$
      ///

    unless match = line.match numberPattern
      console.log "match failed"
      return false

    [all, base, digitsAndUnderscores] = match


    unless 2 <= base <= 16
      return false

    for d in digitsAndUnderscores
      unless -1 < (value = ALL_DIGITS.indexOf d.toLowerCase()) < base
        console.log "digit #{d} with value #{value} is invalid in base #{base}"
        return false

    true
