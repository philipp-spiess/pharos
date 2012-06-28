###
  Socket IO Library
###

Controller = require('../lib/controller').Controller
Redis      = require('./redis').Redis
_          = require 'underscore'

module.exports.user = user = {}
module.exports.admins = admins = []

module.exports.connect = (io) ->
  Redis.getInstance()
  io.sockets.on 'connection', (socket) ->

    if socket.handshake.id?
      id = socket.handshake.id

      # Push the new user socket or create the new user ;)
      if user[id]?
        user[id].push socket
      else
        user[id] = [ socket ]

    else if socket.handshake.admin?
      admins.push socket

    socket.on 'disconnect' , ->
      if socket.handshake.id?
        if user[id].length > 1
          user[id] = _.without user[id], socket
        else
          delete user[id]
      else
        admins = _.without admins, socket

  io.configure ->
    io.set 'authorization', (data, callback) ->

      # Check if this one is an admin.
      if data.query.token is 'pharos:' + process.env.PHAROS_PASSWORD
        data.admin = true
        callback null, true

      else
        # Load Authentication Strategy
        Controller.auth data, callback

module.exports.snitch = snitch = (message) ->
  _.defer ->
    _.each admins, (socket) ->
      socket.emit 'snitch', message
    _.each admins, (socket) ->
      socket.emit message.channel, message.message

module.exports.broadcast = (channel, message) ->
  _.each user, (u) ->
    _.defer ->
      socket.emit channel, message for socket in u

module.exports.push = (channel, to, message) ->
  for id in to
    if user[id]?  
      _.defer ->
        socket.emit channel, message for socket in user[id]
