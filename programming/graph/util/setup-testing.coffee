joe = require 'joe'

unless joe.hasReporters()
  joe.setReporter require('joe-reporter-console').create()

module.exports = joe
