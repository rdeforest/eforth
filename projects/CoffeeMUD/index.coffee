# Console interface
# v0.0 - no options!

db = require('./src/db') '.'
db.load()

db.lookup('sys').start()
