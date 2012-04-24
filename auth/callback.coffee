###
  Basic auth strategy. 
  Requires PHAROS_CALLBACK to be set.
###

request = require 'request'

class Auth
  @auth: (data, callback) ->
    request process.env.PHAROS_CALLBACK + '?token=' + data.query.token , (err, res, body) ->
      if err? or res.statusCode != 200
        callback null, false
      else
        body = JSON.parse(body)
        if body.valid? is true
          # We are valid, proxy the data and get the fuck out here, quik!
          data.id = body.id if body.id?
          data.name = body.name if body.name?
          callback null, true
        else 
          # You should respond with a 401, but well this woll work too
          callback null, false

module.exports = Auth