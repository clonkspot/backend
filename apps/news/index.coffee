# News API.

express = require 'express'

news = require './news'
auth = require '../../lib/auth'
mw = require '../../lib/middleware'

module.exports = app = express()

app.get '/', (req, res) ->
  res.send(news.find(req.query.lang))

app.post '/',
  auth.mw,
  auth.mwRights,
  mw.can('edit_news'),
  (req, res) ->
    item = req.body
    if item._id
      res.send news.update(item)
    else
      res.send 201, news.insert(item)
