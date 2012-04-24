###
  GET log page.
###

auth = require('../lib/auth/server')

module.exports = (req, res) ->
	auth req, res, ->
    res.render 'log', token: 'lol'
