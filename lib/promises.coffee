# Promise helper functions.

# Helper function for converting callbacks to promises.
callback = (reject, resolve) ->
  (err, result) ->
    if err
      reject(err)
    else
      resolve(result)

module.exports = {callback}
