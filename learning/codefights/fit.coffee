(require './genericTester') [
  [ [[1,1,3,4]], 1 ]
  [ [[0,7,9]], 7]
  [ [[-10, -10, -10, -10, -10, -9, -9, -9, -8, -8, -7, -6, -5, -4, -3, -2, -1,
      0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
      18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,
      36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]], 15]
], module.exports =
  absoluteValuesSumMinimization = (a) ->
    test = (n) -> a.map((e) -> Math.abs n - e).reduce (a, b) -> a + b

    a = a.sort()

    if a.length % 2
      m = a[(a.length - 1) / 2]
    else
      m = Math.floor (a[a.length / 2] + a[a.length / 2 - 1])/2

    while test(m - 1) <= test(m)
      m--

    while test(m + 1) < test(m)
      m++

    m
