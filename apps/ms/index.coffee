# Masterserver API

express = require 'express'
request = require 'superagent'
c4ini = require 'c4ini'

module.exports = app = express()

app.get '/cr', (req, res) ->
  masterserverQuery('http://clonk.de:84/league/server', res)

app.get '/oc', (req, res) ->
  masterserverQuery('http://boom.openclonk.org/server/', res)

masterserverQuery = (url, res) ->
  request.get(url).end (ms) ->
    if ms.ok
      try
        obj = c4ini(ms.text)
        res.send(obj)
      catch err
        res.send(500, {error: 'Could not parse masterserver response.'})
    else
      res.send(500, {error: "Masterserver returned error #{ms.status}."})
