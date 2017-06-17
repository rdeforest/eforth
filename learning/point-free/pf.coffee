R = require 'ramda'

prop = (p) -> (x) -> x[p]

exprEq = (e) -> (v) -> v is e()

propEq = exprEq prop
