# Backend application

express = require 'express'

{connected} = require './db/mongo'

# Initialize the application
exports.app = app = express()

# Is the application running in production?
GLOBAL.PRODUCTION = app.get('env') is 'production'

if PRODUCTION
  app.use express.logger()
else
  app.use express.logger 'dev'

app.use express.cookieParser()
app.use express.json()
app.use require('express-promise')()

# Mount modules and run as soon as the database is connected.
connected.then ->
  app.use '/users', require('./apps/users')
  app.use '/news', require('./apps/news')
  app.use '/ms', require('./apps/ms')

  # Error handling
  app.use (err, req, res, next) ->
    res.send 500, {message: err.message}

  # Only run if invoked directly.
  if process.argv[1] is __filename
    PORT = 3236
    app.listen PORT
    console.log "Running on port #{PORT}"
