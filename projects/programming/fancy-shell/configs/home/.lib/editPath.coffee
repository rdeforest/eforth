fs = require 'fs'
{argv, env, stdin, stderr} = require 'process'
buffer = Buffer.from []

action =
  prepend: (paths, path) -> [path, paths...]
  insert:  (paths, path, position) ->
    [ paths[..position]...
      path
      paths[position + 1..] ]
  append:  (paths, path) -> [paths..., path]

stdin
  .on 'data', (data) -> buffer = Buffer.concat [buffer, data]
  .on 'end', ->
    changes = buffer
      .toString 'utf-8'
      .split '\n'
      .filter (l) -> l.match /\S/
      .map (l) ->
        [path, directive = 'append', more] = l.split /\s+/, 3

        if not action[directive]
          console.warn "unknown directive: #{directive}, assuming 'append'"
          directive = 'append'

        {directive, path, more}
      .reduce (({remove, add}, change) ->
          {directive, path} = change
          remove.push path

          if directive isnt 'remove'
            add.push {directive, path, more}

          {remove, add}
        ), {remove: [], add: []}

    paths = []
    if argv[0] isnt '-c' then paths = env.PATH.split(':').filter (p) -> p not in changes.remove

    for {directive, path, more} in changes.add
      paths = action[directive] paths, path, more

    console.log paths.join ":"

