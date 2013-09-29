# Helper middleware.

# Continues only if the predicate returns truthy.
exports.is = (what, errcode, fun) ->
  (req, res, next) ->
    if fun(req, res)
      next()
    else
      res.send errcode, {message: 'Must be ' + what}
