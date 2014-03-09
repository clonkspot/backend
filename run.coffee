# Runs the application.

app = require './app'
{connected} = require './db/mongo'
cfg = require './config'

# Wait for the db connection.
connected.then ->
  PORT = cfg.get 'port'
  app.listen PORT
  console.log "Running on port #{PORT}"
