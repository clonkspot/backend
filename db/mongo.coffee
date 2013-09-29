# MongoDB connection.

{MongoClient} = require 'mongodb'
rsvp = require 'rsvp'

conf = require '../config'

# Use a Promise to indicate connection status.
connected = null
exports.connected = new rsvp.Promise (resolve, reject) ->
  connected = resolve

MongoClient.connect conf.get('mongodb'), (err, db) ->
  throw err if err

  exports.db = db
  connected(db)
