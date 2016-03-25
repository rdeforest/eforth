{Maze, Pin, Path} = require './maze'

(exampleMaze = new Maze)
  .connect    0, 14, 15, {a: 0}
  .connect    1, {a: 3}
  .connect    2, 11, {a: 4}, {b: 6}, {c: 0}
  .connect    3, {b: 0}

  .connect    4, {b: 3}
  .connect    5, {b: 7}
  .connect    6, {a: 2}, {c: 5}
  .connect    7, 9, 12, {a: 10}

  .connect    8, {b: 2}
  .connect   10, 13, {a: 13}

  .connect {a:  7}, {b: 15}
  .connect {a:  8}, {c: 12}
  .connect {a:  9}, {a: 15}
  .connect {a: 11}, "minus"

  .connect {b: 10}, {c: 3}
  .connect {b: 13}, {c: 14}

  .connect {c: 6}, {c: 7}
  .connect {c: 9}, "plus"

  .addPath   9, {a: [10, 13]}, 10
  .addPath   0, {a: [0, 15]}, {a: [9, 7]}, {b: [15, 0]}, 3

