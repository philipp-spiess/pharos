###
  A little helper for redis ;) 

  Used env vars
  PHAROS_REDIS_URL
###

redis = require 'redis'
url   = require 'url'

class Redis
  # A tiny Singelton wrapper
  @getInstance: ->
    unless @instance?
      @instance = new Redis
    @instance

  constructor: ->
    rtg = url.parse(process.env.PHAROS_REDIS_URL)

    # One client who can push and one to simply subscribe :)
    @client = redis.createClient rtg.port, rtg.hostname
    @sub    = redis.createClient rtg.port, rtg.hostname

    @client.auth rtg.auth.split(":")[1]
    @sub.auth rtg.auth.split(":")[1]

    @client.on 'error', (err) =>
      console.log '[Redis][Client] Error: ' + err
 
 
    @sub.on 'error', (err) =>
      console.log '[Redis][Sub] Error: ' + err




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