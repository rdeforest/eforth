fs            = require 'fs'
path          = require 'path'
assert        = require 'assert'

{suite, test} = require 'joe'

{dirEntries}  = require '..'

mkdir = fs.mkdirSync
mkTempDir = fs.mkdtempSync

DIR_WIDTH    = 5
DIR_DEPTH    = 5
LEAF_FILES   = 5
BRANCH_FILES = 5

mkfiles = (dir, count) ->
  if count and count > 0
    for n in [1..count]
      fs.writeFileSync path.resolve(dir, n.toString()), ""

mktree = (dir, depth = DIR_DEPTH) ->
  for n in [1 .. DIR_WIDTH]
    subdir = mkTempDir path.resolve dir, n.toString()

    if depth > 0
      mkfiles subdir, BRANCH_FILES
      mktree subdir, depth - 1
    else
      mkfiles subdir, LEAF_FILES

suite "", (suite, test, complete) ->
  testdir = mktree mkTempDir path.resolve __dirname, 'test-tree'

  topEntries = dirEntries testdir
  found = entry for entry from topEntries when not entry.startsWith '.'

  test "", (complete) ->
    assert.equal found.length, DIR_WIDTH, "Found expected number of top-level entries"

