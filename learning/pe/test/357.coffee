
{ assert, suite, test } = require '../node_modules/rdf/lib/setup-testing'

solution = require '../357'

test '29', -> assert not solution.isGenerator 29

test '30', -> assert     solution.isGenerator 30


