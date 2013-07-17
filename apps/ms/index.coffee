# Masterserver API

express = require 'express'
request = require 'superagent'
c4ini = require 'c4ini'

module.exports = app = express()

app.get '/cr', (req, res) ->
  request.get('http://clonk.de:84/league/server').end (ms) ->
    if ms.ok
      try
        obj = c4ini(ms.text)
        res.send(obj)
      catch err
        res.send(500, {error: 'Could not parse masterserver response.'})
    else
      res.send(500, {error: "Masterserver returned error #{ms.status}."})
