# Backend application

express = require 'express'

# Initialize the application
exports.app = app = express()

# Is the application running in production?
GLOBAL.PRODUCTION = app.get('env') is 'production'

if PRODUCTION
  app.use express.logger()
else
  app.use express.logger 'dev'

# Mount modules.
app.use '/ms', require('./apps/ms')

# Only run if invoked directly.
if process.argv[1] is __filename
  PORT = 3236
  app.listen PORT
  console.log "Running on port #{PORT}"
