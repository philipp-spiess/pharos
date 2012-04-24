###
  RESTful Push interface
###

auth = require '../lib/auth/server'
io = require '../lib/socket.io'

module.exports = (req, res) ->
  auth req, res, ->
    res.header "Content-Type", "application/json"

    channel = req.params.channel

    ## Check if the message is a json object or just some shiny JS-String
    message = req.body.message
    try
      message = JSON.parse message

    request = {
      channel: channel,
      message: message
    }
        
    if req.body.to?
      if typeof req.body.to == 'string'
        req.body.to = [ req.body.to ]

      request.type = 'PUSH'
      request.to = req.body.to
    else
      request.type = 'BROADCAST'
        
    res.send JSON.stringify request

    if request.to?
      io.push request.channel, request.to, request.message
