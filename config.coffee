convict = require 'convict'

conf = convict
  mysql:
    doc: 'The MySQL connection string.'
    default: 'mysql://root:@localhost/mwf'
    format: 'url'
    env: 'MWF_MYSQL'

  mongodb:
    doc: 'The MongoDB connection url.'
    default: 'mongodb://localhost:27017/clonkspot'
    format: (s) -> /^mongodb:\/\//.test(s) # URL doesn't accept mongodb as protocol
    env: 'CLONKSPOT_MONGODB'

conf.validate()

module.exports = conf
