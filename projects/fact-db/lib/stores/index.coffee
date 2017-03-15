fs = require 'fs'

stores = {}

for f in fs.readdirSync '.' when f.endsWith '.coffee'
  first ?= stores[b = path.basename f, '.coffee'] = require './' + b

stores.default ?= first

module.exports = stores
