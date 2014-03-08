# News MongoDB interface.

rsvp = require 'rsvp'
_ = require 'underscore'
{ObjectID} = require 'mongodb'

{db} = require '../../db/mongo'
prh = require '../../lib/promises'

news = db.collection 'news'
fields = 'title link author type date lang'.split ' '

# Validates a news entry.
validate = (entry) ->
  _.every fields, (field) ->
    field of entry and _.isString entry[field]

# Prepares an item for saving.
# Returns a promise.
prepareItem = (entry) ->
  new rsvp.Promise (resolve, reject) ->
    if validate(entry)
      resolve(_.pick(entry, fields))
    else
      reject(new Error('Invalid fields.'))

# Inserts a news entry into the collection.
insert = (entry) ->
  prepareItem(entry).then (filtered) ->
    new rsvp.Promise (resolve, reject) ->
      news.insert filtered,
                  prh.callback reject, -> resolve(filtered)

# Updates an entry.
update = (entry) ->
  prepareItem(entry).then (filtered) ->
    new rsvp.Promise (resolve, reject) ->
      news.findAndModify {_id: new ObjectID(entry._id)},
        [['_id', 1]],
        {$set: filtered},
        {new: true},
        prh.callback(reject, resolve)

# Finds the four newest entries.
find = (lang) ->
  new rsvp.Promise (resolve, reject) ->
    news.find({lang})
      .sort('date', -1)
      .limit(4)
      .toArray prh.callback(reject, resolve)

module.exports = {insert, update, find}
