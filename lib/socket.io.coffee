###
  Socket IO Library
###

_ = require('underscore')
sockets = []

module.exports.connect = (io) ->
  io.sockets.on 'connection', (socket) ->
    sockets.push socket

    socket.on 'disconnect' , ->
      sockets = _.without sockets, socket

module.exports.broadcast = (channel, message) ->
  socket.emit channel, message for socket in sockets

