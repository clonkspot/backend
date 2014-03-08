# Authentication middleware

_ = require 'underscore'
rsvp = require 'rsvp'

mysqlquery = require '../db/mysql'
conf = require '../config'

userrights = require './userrights'

# Returns a promise for a user object.
getUser = (uid) ->
  mysqlquery('SELECT * FROM users WHERE id=?', [uid])
    .then (result) ->
      if result.length
        result[0]
      else
        throw new Error('User not found.')

# Returns a promise with an array of the user's groups.
getGroups = (uid) ->
  mysqlquery('''
    SELECT groups.id, groups.title
      FROM groups AS groups
        INNER JOIN groupMembers AS groupMembers
          ON groupMembers.userId = ?
          AND groupMembers.groupId = groups.id
  ''', [uid])

# Tries to authenticate by login cookie.
authenticate = (cookie) ->
  fail = new Error('Invalid login cookie.')
  return rsvp.reject(fail) unless _.isString cookie
  [uid, loginAuth] = cookie.split ':'
  getUser(+uid).then (user) ->
    if user.loginAuth is loginAuth
      user
    else
      fail

# Middleware attaching the user to the request object.
mw = (req, res, next) ->
  authenticate(req.cookies[conf.get('mwf_cookie')])
    .then (user) ->
      res.locals.user = user
      next()
    , (err) ->
      res.send(403, {message: err.message})

# Middleware adding user rights.
#
# The authenication middleware (above) has to be run first.
mwRights = (req, res, next) ->
  user = res.locals.user
  getGroups(user.id).then (groups) ->
    rights = {}
    for key, hasRight of userrights
      rights[key] = true if user.admin or hasRight(user, groups)
    user.rights = rights
    next()

module.exports = {getUser, getGroups, mw, mwRights}
