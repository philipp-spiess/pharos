
/*
 * GET /pharos.js
 */

var fs = require('fs')
  , cache = {}
  , socket_io_client = 'node_modules/socket.io/node_modules/socket.io-client/dist/socket.io.js'
  , pharos_client = 'dist/pharos.js'

module.exports = function(req, res) {

  res.header("Content-Type", "application/javascript");

  fs.readFile(socket_io_client, function(err, socket_io_client_data) {
    if (err) throw err
    fs.readFile(pharos_client, function(err, pharos_client_data) { 
      if (err) throw err

      res.send(socket_io_client_data.toString() + pharos_client_data.toString())
    })
  })
}
