# Runs the application.

app = require './app'
{connected} = require './db/mongo'

# Wait for the db connection.
connected.then ->
  PORT = 3236
  app.listen PORT
  console.log "Running on port #{PORT}"
