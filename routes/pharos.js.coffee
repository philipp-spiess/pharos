###
  GET /pharos.js
###

fs = require 'fs'
coffee = require 'coffee-script'
socket_io_client = 'node_modules/socket.io/node_modules/socket.io-client/dist/socket.io.js'
pharos_client = 'dist/pharos.coffee'
cache = {}

module.exports = (req, res) ->
  res.header "Content-Type", "application/javascript"

  # Cache to minimize I/O
  unless cache.socket_io? or cache.pharos?
    # Load the fucking files babe!
    cache.socket_io = fs.readFileSync( socket_io_client ).toString()
    cache.pharos = fs.readFileSync( pharos_client ).toString()

  # Prepare the options
  opt =
    base_url: process.env.PHAROS_BASE_URL
    token: req.query?.token

  # @todo use uglifyjs
  res.send cache.socket_io + coffee.compile( cache.pharos.replace(':opt', JSON.stringify ( opt ) ) )