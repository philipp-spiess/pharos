###
  Socket IO Library
###

Redis = require('./redis').Redis
_ = require 'underscore'

module.exports.user = user = {}
module.exports.connect = (io) ->
  Redis.getInstance()
  io.sockets.on 'connection', (socket) ->
    id = socket.handshake.id

    # Push the new user socket or create the new user ;)
    if user[id]?
      user[id].push socket
    else
      user[id] = [ socket ]

    socket.on 'disconnect' , ->
      if user[id].length > 1
        user[id] = _.without user[id], socket
      else
        delete user[id]

  io.configure ->
    io.set 'authorization', (data, callback) ->
      # Load Authentication Strategy
      strategy = require '../auth/' + process.env.PHAROS_AUTH_STRATEGY
      strategy.auth data, callback

module.exports.broadcast = (channel, message) ->
  _.each user, (u) ->
    socket.emit channel, message for socket in u

module.exports.push = (channel, to, message) ->
  for id in to
    if user[id]?
      socket.emit channel, message for socket in user[id]
