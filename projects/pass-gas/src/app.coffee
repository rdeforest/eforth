express      = require 'express'
path         = require 'path'
favicon      = require 'serve-favicon'
logger       = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser   = require 'body-parser'

resolveDir   = (more...) -> path.resolve __dirname, more...
route        = (routeName) -> resolveDir 'routes', routeName
views        = resolveDir 'views'

index        = require route 'index'
users        = require route 'users'

app          = express()

# view engine setup
app.set 'views'       , views
app.set 'view engine' , 'pug'

# uncomment after placing your favicon in /public
#app.use favicon(path.join(__dirname, 'public', 'favicon.ico')))
app.use logger 'dev'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: false
app.use cookieParser()
app.use express.static resolveDir 'public'
app.use '/', index
app.use '/users', users

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error 'Not Found'
  err.status = 404
  next err
  return

# error handler
app.use (err, req, res, next) ->
  # set locals, only providing error in development
  res.locals.message = err.message
  res.locals.error =
    if req.app.get 'env' is 'development'
      err
    else
      {}

  # render the error page
  res.status err.status or 500
  res.render 'error'
  return

module.exports = app
