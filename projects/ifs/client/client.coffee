console.log 'requiring loopback'
loopback = require 'loopback'

console.log 'requiring loopback-boot'
boot = require 'loopback-boot'

console.log 'creating app'
app = module.exports = loopback()

app.start = ->
  console.log "Something called app.start with", arguments

console.log 'calling boot'
boot app, __dirname, (err) ->
  console.log "boot callback invoked with", arguments

console.log 'Models: ', Object.keys app.models
