###
  GET home page.
###

auth = require('../lib/auth/server')

module.exports = (req, res) ->
	auth req, res, ->
		res.render 'index', title: 'data', token: 'lol'