###
  RESTful info (api) interface
###

auth  = require '../lib/auth/server'
redis = require('../lib/redis').Redis.getInstance()
io    = require '../lib/socket.io'
_     = require 'underscore'

module.exports = (req, res) ->
  auth req, res, ->
    res.header "Content-Type", "application/json"

    what = req.params.what
    id   = req.params.id if req.params.id?

    available = ['user', 'log', 'stats']

    if what is 'user'
      user = []
      _.each io.user, (u, id) ->
        user.push
          id:      id
          name:    u[0].handshake.name
          sockets: u.length
      res.send JSON.stringify user

    else if what is 'log'
      redis.list 'pharos:push:log', (json_list) ->
        list = []
        for l in json_list
          list.push JSON.parse(l)
        if id?
          list = _.first list, id
        res.send JSON.stringify list

    else if what is 'stats'
      user    = 0
      sockets = 0
      _.each io.user, (u) ->
        user++
        sockets += u.length

      redis.client.get 'pharos:push:cnt', (err, cnt) ->
        stats =
          pushed  : parseInt cnt
          user    : user
          sockets : sockets

        res.send JSON.stringify stats

    else
      res.send JSON.stringify 
        error:     'not found'
        available: available
