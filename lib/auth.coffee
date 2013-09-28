# Authentication middleware

mysqlquery = require '../db/mysql'

# Returns a promise for a user object.
getUser = (uid) ->
  mysqlquery('SELECT * FROM users WHERE id=?', [uid])
    .then (result) ->
      if result.length
        result[0]
      else
        throw new Error('User not found.')

# Tries to authenticate by login cookie.
authenticate = (cookie) ->
  [uid, loginAuth] = cookie.split ':'
  getUser(+uid).then (user) ->
    if user.loginAuth is loginAuth
      user
    else
      throw new Error('Invalid login cookie.')

# Middleware attaching the user to the request object.
mw = (req, res, next) ->
  authenticate(req.cookies.mwf_login)
    .then (user) ->
      res.locals.user = user
      next()
    , (err) ->
      res.send(403, {error: err.message})

module.exports = {getUser, mw}
