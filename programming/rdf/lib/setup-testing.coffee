moduleNames = 'assert fs events path process util'.split ' '
modules     = Object.assign {}, (moduleNames.map (mod) -> "#{mod}": require mod)...
{ env }     = modules.process
{ path }    = modules

if env.NODE_PATH
  env.NODE_PATH  += ':'
else
  env.NODE_PATH   = ''

env.NODE_PATH    += '../lib'

env.JOE_REPORTER ?= 'console'

Object.assign exports, require('joe'), modules
