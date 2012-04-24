###
  The Controller knows everything
###

Redis = require('./redis').Redis
io = require('../lib/socket.io')

class Controller
  @work: ->
    # Connecto to redis
    @redis = Redis.getInstance()

    @redis.sub.on 'pmessage', (pattern, channel, message) ->
      if channel is 'pharos:push'
        Controller.processPush JSON.parse message

    @redis.sub.psubscribe 'pharos:*'      

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
    console.log '[Controller] Got something to publish. Neat.'
    if request.to?
      io.push request.channel, request.to, request.message
    else
      io.broadcast request.channel, request.message







module.exports.Controller = Controller