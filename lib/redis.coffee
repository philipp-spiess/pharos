###
  A little helper for redis ;) 
###

redis = require 'redis'

class Redis
  # A tiny Singelton wrapper
  @getInstance: ->
    unless @instance?
      @instance = new Redis
    @instance

  constructor: ->
    # One client who can push and one to simply subscribe :)
    @client = redis.createClient()
    @sub = redis.createClient()

    err = (err) ->
      console.log '[Redis] Error: ' + err
    @client.on 'error', err
    @sub.on 'error', err

  # Log em!
  log: (type, json) ->
    if type is 'push'
      @client.lpush 'pharos:push:log', json
      @client.ltrim 'pharos:push:log', 0, 50
      @client.incr  'pharos:push:cnt'


  list: (key, fn) =>
    @client.lrange key, 0, -1, (err, list) ->
      throw err if err
      fn? list




module.exports.Redis = Redis