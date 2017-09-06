# Given a sorted list of "paths", list only the leaves.
# Path separators are not special, so "a" is a prefix for "aa" and "ab".
# Also format the output in a way which preserves the original information
#   a -> a
#        b

# First attempt will convert the list to a dictionary, then output that

process = require 'process'

# stream to string
gather = (instream) ->
  buf = Buffer.from ''

  new Promise (resolve, reject) ->
    buf = Buffer.from ''

    instream
      .on 'data',  (data) -> data = Buffer.concat data, buf
      .on 'end',          -> resolve buf.toString()
      .on 'error',    (e) -> reject e

firstNewParentIdx = (parent, children) ->
  children.findIndex (l) -> not l.startsWith parent

outdent = (prefixLen, lines) ->
  lines.map (l) ->
    l[prefixLen..]

indent = (columns, lines) ->
  spaces = ' '.repeat columns
  lines.map (l) -> spaces + l

sameFirstChar = ([first, strings...]) ->
  if strings.length and strings[0].length
    fchar = first[0]

    for s in strings[1..] when s[0] isnt fchar
      return

    fchar

processLines = (lines) ->
  lines = lines.slice()
  tree  = {}

  while lines.length
    [prefix, lines...] = lines

    if 0 is idx = firstNewParentIdx prefix, lines
      tree[prefix] = {}
      continue

    children = lines[..idx - 1]
    children = outdent prefix.length, children
    lines = lines[idx..]

    if 'string' is typeof fchar = sameFirstChar children
      prefix += fchar
      children = outdent 1, children

    tree[prefix] = processLines children

  return tree

renderTree = (tree, prefixLen = 0) ->
  lines = []

  for k, v of tree
    kids = renderTree v, prefixLen + k.length

    lines =
      if kids.length
        lines.concat k + kids[0],
                     indent k.length,
                            outdent k.length, kids[1..]
      else
        lines.concat k

  lines

lines = """
    PlantUMLPlus/lib
    buildings/helix
    learning
    learning/codefights/done
    learning/crystal/worm/src/worm
    learning/ramda-experiments
    lonely-scripts
    my_node_modules
    my_node_modules/all
    my_node_modules/all/test
    notes
    notes/trinket
    projects
    projects/AnotherMUD
    projects/AnotherMUD/lib
    projects/chaos
    projects/coffee-browser
    projects/coffee-browser/src
    projects/CSGO
    projects/CSGO/analysis
    projects/CSGO/analysis/2017
    projects/CSGO/analysis/2017/ESL Pro League Season 6 - Odense
    projects/CSGO/analysis/2017/ESL Pro League Season 6 - Odense/Group Stage
    projects/CSGO/analysis/2017/ESL Pro League Season 6 - Odense/Group Stage/Week 1
    projects/fancy-shell/configs/home
    projects/generator-projects
    projects/generator-projects/__tests__
    projects/generator-projects/generators
    projects/generator-projects/generators/app
    projects/generator-projects/generators/app/templates
    projects/joe-reporter-api
    projects/pass-gas
    projects/pass-gas/bin
    projects/pass-gas/public
    projects/pass-gas/public/images
    projects/pass-gas/public/javascripts
    projects/pass-gas/public/stylesheets
    projects/pass-gas/src
    projects/pass-gas/src/routes
    projects/pass-gas/src/views
    projects/pass-gas/test
    projects/sandbox
    projects/sandbox/test
  """.split '\n'

Object.assign global, module.exports, {
  processLines, firstNewParentIdx
  gather, renderTree, lines, indent
  outdent, sameFirstChar
}
