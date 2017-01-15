I did not read all the comments, so I apologize for any redundancy.

I found this issue looking for a way to iterate over the contents of a
directory without loading the entire directory into memory first. Several
times in my career I have encountered situations where a directory has grown
to contain over 100 million entries either through bad design, a bug or
negligence. In each case where the contents of the directory mattered and
needed to be adjusted with a scalpel I've used something like

    $ perl -e 'opendir(D, "."); while (<D>) { ... }'

because it doesn't stat() the entries
themselves and doesn't try to load the entire list of directory entries into
memory before passing them to my code.

In the NodeJS universe I would expect something like the following
CoffeeScript to work:

    fs = require 'fs'

    scanDir = (path, inspector) ->
      new Promise (resolve, reject) ->
        results = []

        examineEntry = (err, entry, more) ->
          if err
            return reject err

          try
            results.push inspector entry
            more examineEntry
          catch e
            return reject e

        fs.opendir path, examineEntry
          .then -> resolve results
