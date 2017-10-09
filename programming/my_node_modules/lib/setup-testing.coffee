(require 'process')
  .env
  .JOE_REPORTER ?= 'console'

Object.assign module.exports, require('joe'), assert: require 'assert'
