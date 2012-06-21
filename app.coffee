express = require('express')
stylus = require('stylus')
util = require('util')
io = require('socket.io')
socket = require('./lib/socket.io')
Controller = require('./lib/controller').Controller

# Check the dependencies 

unless process.env.PHAROS_PASSWORD?
  util.puts 'No secret found. Please set PHAROS_PASSWORD.'
  process.exit 1

unless process.env.PHAROS_REDIS_URL?
  util.puts 'No redis found. Please set PHAROS_REDIS_URL.'
  process.exit 1

unless process.env.PHAROS_AUTH_STRATEGY?
  util.puts 'No auth stragety found. Plesase set PHAROS_AUTH_STRATEGY.'
  process.exit 1



# Create server and connect to socket.io
app = express.createServer()
socket.connect io.listen(app)

# Config
app.configure ->
  if process.env.NODE_ENV isnt 'production'
    app.use stylus.middleware
      debug: true
      src: __dirname + '/public'
      dest: __dirname + '/public'
      compile: (str) ->
        stylus(str).set 'compress', true
  
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

# Routes
app.get  '/',                 require('./routes/index')
app.get  '/log',              require('./routes/log')
app.get  '/user',             require('./routes/user')
app.get  '/pharos(.min)?.js', require('./routes/pharos.js')
app.post '/push/:channel',    require('./routes/push')
app.get  '/api/:what/:id?',   require ('./routes/api')

app.listen process.env.PORT ?= 3000, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

Controller.work()

module.exports = app