/**
 * Module dependencies.
 */

var express = require('express')
  , stylus = require('stylus')
  , io = require('socket.io')
  , socket = require('./lib/socket.io')
  , _ = require('underscore')

var app = module.exports = express.createServer()

socket.connect(io.listen(app))

// Configuration

app.configure(function() {
  app.use(stylus.middleware( {
      debug: true
    , src: __dirname + '/public'
    , dest: __dirname + '/public'
    , compile: function(str) {
        return stylus(str)
          .set('compress', true)
    }
  }));

  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')

  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
});

app.configure('development', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
});

app.configure('production', function() {
  app.use(express.errorHandler())
});

// Routes
var r = require('./routes/index.js')
console.log(r)
app.get('/', require('./routes/index'))
app.get('/pharos(.min)?.js', require('./routes/pharos.js'))

app.listen(80, function() {
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
});
