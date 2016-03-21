assert = require 'assert'

{Maze, Pin, Path} = require '../maze'


describe 'Maze', ->
  it 'should construct', ->
    maze = new Maze

  it 'should canonize pin input', ->
    maze = new Maze
    [noMaze, withMaze, number] = maze.canonical 'example', maze: 'pin', 1
    assert.equal noMaze.name, 'example'
    assert.equal withMaze.name, 'pin'
    assert.equal withMaze.maze, 'maze'
    assert.equal number.name, '1'

  it 'should canonize multi-string pin input', ->
    maze = new Maze
    [first, second] = maze.canonical 'first', 'second'
    assert.equal first.name, 'first'
    assert.equal second.name, 'second'

  it 'should generate pins and wires via the .connect interface', ->
    (maze = new Maze)
      .connect 'zero', 'one'

    assert maze.pins.zero.connected maze.pins.one

  it 'should propagate connections', ->
    (maze = new Maze)
      .connect ("beginning to end".split ' ')...

    assert maze.pins.beginning.connected maze.pins.end

  it 'should put pins in the right maps', ->
    (maze = new Maze)
      .connect 1, inner: 2

    assert     maze.outerPins["1"]
    assert     maze.innerPins["inner.2"]
    assert not maze.outerPins["inner.2"]
    
  it 'should connect through submazes', ->
    (maze = new Maze)
      .connect 1, 2
      .connect 'plus', subMaze: 1
      .connect subMaze: 2, 'minus'

    console.log maze.outerPins
    assert maze.pins.plus.connected maze.pins.minus
          
  it 'should connect through connected submazes', ->
    maze
      .connect a: 3, b: 1
      .connect b: 2, 'bMinus'

    assert maze.plus.connected maze.bMinus

  it 'should connect through outer-self-connected submazes', ->
    maze
      .connect b: 3, b: 4
      .connect 4, 5
      .connect b: 5, "cMinus"

    assert maze.plus.connected maze.cMinus
