###
  The Controller knows everything
###

Redis = require('./redis').Redis
io    = require('../lib/socket.io')

class Controller
  @work: ->
    # Connecto to redis
    @redis = Redis.getInstance()

    @redis.sub.on 'pmessage', (pattern, channel, message) ->
      if channel is 'pharos:push'
        Controller.processPush JSON.parse message

    @redis.sub.psubscribe 'pharos:*'   

    ## Initialize auth strategy (perhaps they need to contact a DB?) 
    @strategy = new (require '../auth/' + process.env.PHAROS_AUTH_STRATEGY)

  ###
    Methods before queue
  ###

  @push: (request) ->
    request = JSON.stringify request

    @redis.client.publish 'pharos:push', request
    @redis.log 'push', request

  ###
    Methods after queue
  ###

  @processPush: (request) ->

    io.snitch request

    console.log '[Controller] Got something to publish. Neat.'
    if request.to?
      io.push request.channel, request.to, request.message
    else
      io.broadcast request.channel, request.message

  @auth: (data, callback) ->
    @strategy.auth data, callback

module.exports.Controller = Controller