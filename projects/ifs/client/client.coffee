loopback = require 'loopback'
boot = require 'loopback-boot'

app = module.exports = loopback()
boot app

console.log 'Models: ', Object.keys app.models
