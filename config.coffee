convict = require 'convict'

conf = convict
  mysql:
    doc: 'The MySQL connection string.'
    default: 'mysql://root:@localhost/mwf'
    format: 'url'
    env: 'MWF_MYSQL'

conf.validate()

module.exports = conf
