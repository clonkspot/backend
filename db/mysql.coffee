# MySQL connection handling for authentication.

mysql = require 'mysql'
rsvp = require 'rsvp'
_ = require 'underscore'

conf = require '../config'

pool = mysql.createPool(conf.get('mysql'))

# Exports a promise returning query function.
module.exports = ->
  qargs = _.toArray(arguments)

  new rsvp.Promise (resolve, reject) ->
    pool.getConnection (err, conn) ->
      return reject(err) if err

      qargs.push (err, results) ->
        return reject(err) if err
        conn.release()
        resolve(results)

      conn.query.apply(conn, qargs)

