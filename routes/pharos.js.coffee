###
  GET /pharos.js
###

fs = require 'fs'
cache = {}
socket_io_client = 'node_modules/socket.io/node_modules/socket.io-client/dist/socket.io.js'
pharos_client = 'dist/pharos.coffee'
coffee = require 'coffee-script'

module.exports = (req, res) ->
  res.header "Content-Type", "application/javascript"

  socket_io_client_data = fs.readFileSync( socket_io_client ).toString()
  pharos_client_data = coffee.compile( fs.readFileSync( pharos_client ).toString() )

  res.send socket_io_client_data + pharos_client_data