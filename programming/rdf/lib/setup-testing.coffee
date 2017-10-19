modules = {}
(modules[mod] = require mod) for mod in 'fs assert path events process'.split ' '
{env} = modules.process

env.JOE_REPORTER ?= 'console'
env.NODE_PATH    += ':' if env.NODE_PATH
env.NODE_PATH    += '../lib'

Object.assign module.exports, require('joe'), modules
