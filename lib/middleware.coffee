# Helper middleware.

# Continues only if the predicate returns truthy.
exports.is = (what, errcode, fun) ->
  (req, res, next) ->
    if fun(req, res)
      next()
    else
      res.send errcode, {message: 'Must be ' + what}

# Continues only if the user has the given right.
#
# Needs the user and rights middleware beforehand.
exports.can = (what) ->
  exports.is "able to #{what}", 403, (req, res) ->
    res.locals.user.rights[what]
