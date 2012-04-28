###
  A humongous auth strategy.
  Requires PHAROS_MONGO_URL to be set.
###

connect = require('mongodb').connect
crypto  = require 'crypto'
_       = require 'underscore'

class Auth
  constructor: ->
    connect process.env.PHAROS_MONGO_URL, (err, db) ->

      # Edit your collection here
      db.collection 'users', (err, collection) ->
        @collection = collection

  auth: (data, callback) =>

    if collection?

      collection.findOne authentication_token: data.query.token, (err, result) ->
        if err?
          callback err, false
        else if result?

          # <edit>
          data.id     = result._id
          data.name   = result.nickname
          data.avatar = 'https://secure.gravatar.com/avatar/' + crypto.createHash('md5').update(result.email).digest('hex')
          # </edit>

          callback null, true
        else
          callback null, false

    else
      # Retry in 1 sec.
      _.delay ( =>
        @auth data, callback
      ), 1000

module.exports = Auth