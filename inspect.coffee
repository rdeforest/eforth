module.exports = inspect =
  inferedName: (o) ->
    if typeof o in ['object', 'function']
      if name = o.name
        return name

      for name, value of o
        if value is o
          return name

  props: (o) ->
    Object.getOwnPropertyNames o

  names: (namespace, nsName = inspect.inferedName(namespace), objects...) ->
    if not objects.length
      return inspect.allNames namespace, nsName

    return inspect._names {}, namespace, nsName, objects

  # modifies found as side-effect
  _names: (found, namespace, nsName, objects) ->
    for name in inspect.props namespace
      value = namespace[value]
      fullName = "#{nsName}.#{name}"

      if value in objects
        found[fullName] = value

      if typeof value in ['object', 'function']
        inspect.names found, value, fullName, objects...

    return found

  # modifies found as side-effect
  allNames: (namespace, nsName = inspect.inferedName(namespace), found = {}) ->
    for name in inspect.props namespace
      value = namespace[value]
      fullName = "#{nsName}.#{name}"

      if typeof value in ['object', 'function']
        found[fullName] = value
        inspect.allNames value, fullName, found

    return found

  columnize: columnize = (list, overrides = {}) ->
    opts =
      maxWidth: console._stdout.columns - 1
      asTable: false
      rowsAreLists: false
      columnSeparator: ' '
      columnDivider: ' '
      likeCRT: false
      rightJustify: false

    for k, v of overrides
      opts[k] = v

    if opts.asTable
      columnize.table list, opts
    else
      columnize.fill list, opts

  _justify: justify_ = (s, width, spaces, right = false) ->
    if right
      spaces[0 .. width - s.length] + s
    else
      s + spaces[0 .. width - s.length]

columnize.fill = (list, opts) ->
  list = list.map (e) -> e.toString()
  longest = list.map((s) -> s.length).reduce((a,b) -> if a < b then b else a)
  columns = Math.floor (opts.maxWidth + 1) / (longest + 1)
  rows = Math.ceil list.length / (columns or 1)
  spaces = ' '.repeat longest

  list = list.map (s) -> inspect._justify s, longest, spaces, opts.rightJustify

  lines = []

  if opts.likeCRT
    for y in [0 .. rows - 1]
      list
        .splice 0, columns
        .join opts.columnDivider
  else
    for y in [0 .. rows - 1]
      (list[y * rows + x] for x in [0 .. columns - 1])
        .join opts.columnDivider

columnize.table = (list, opts) ->
  rows = []
  colWidths = []
  longest = 0

  for row in list
    if opts.rowsAreLists
      row = row.map (e) -> e.toString()
    else
      row = row.toString().split(opts.columnSeparator)

    for cell, i in row
      len = cell.length
      longest = len if len > longest

      if colWidths.length - 1 < i
        colWidths.push len
      else
        colWidths[i] = len if len > colWidths[i]

    rows.push row

  spaces = ' '.repeat longest

  for row in rows
    (inspect._justify cell, colWidths[i], spaces, opts.rightJustify for cell, i in row)
      .join opts.columnDivider

