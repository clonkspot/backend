# Users resource.

express = require 'express'
_ = require 'underscore'

auth = require '../../lib/auth'

module.exports = app = express()

# Public fields
fields = 'id userName realName avatar admin rights'.split ' '

app.get '/me',
  auth.mw,
  auth.mwRights,
  (req, res) ->
    res.send _.pick res.locals.user, fields
