###
  GET user page.s
###

auth = require('../lib/auth/server')

module.exports = (req, res) ->
  auth req, res, ->
    res.render 'user', page: 'user'
