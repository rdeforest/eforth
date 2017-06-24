__ = require 'underscore'
root.__ = __
root.logger = require './lib/logger'
root.data = require './example-data'

__.extend root, __.pick logger, 'q start stop day month year entries'.split ' '

