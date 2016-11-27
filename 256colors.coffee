#!/usr/bin/env coffee

escape = (s) -> "\x1b" + s

CSI = (cmd, args...) ->
  escape '[' + args.join(';') + cmd

SGR = (args...) ->
  CSI 'm', args...

Object.setPrototypeOf SGR,
  reset           :     -> SGR()
  bold            :     -> SGR 1
  faint           :     -> SGR 2
  italic          :     -> SGR 3
  underline       :     -> SGR 4
  blink           :     -> SGR 5
  fastBlink       :     -> SGR 6
  reverse         :     -> SGR 7
  conceal         :     -> SGR 8
  strikeout       :     -> SGR 9
  resetFont       :     -> SGR 10
  font            : (n) -> SGR 10 + n
  boldOff         :     -> SGR 22
  italicOff       :     -> SGR 23
  underlineOff    :     -> SGR 24
  blinkOff        :     -> SGR 25
  unReverse       :     -> SGR 27
  reveal          :     -> SGR 28
  strikeoutOff    :     -> SGR 29

  setForeground   : (n)     -> SGR 30 + n
  extFgColor      : (n)     -> SGR 38, 5, n
  setFgRGB        : (r,g,b) -> SGR 38, 2, r, g, b

  setBackground   : (n)     -> SGR 40 + n
  extBgColor      : (n)     -> SGR 48, 5, n
  setBgRGB        : (r,g,b) -> SGR 48, 2, r, g, b

  setColors       : (fg, bg) -> SGR 30 + fg, 40 + bg

process = require 'process'

console.log SGR.setColors(6,4) + "Woo, color!" + SGR.reset()
process.exit 0

grid = ""
for y in [0 .. 15]
  for x in [0 .. 15]
    c = y * 16 + x
    grid += (SGR.setBgRGB c, c, c) + "  "
  grid += "\n"

console.log grid

