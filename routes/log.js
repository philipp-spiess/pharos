
/*
 * GET log page.
 */

var auth = require('../lib/auth/server')

module.exports = function(req, res) {
  auth(req, res, function() {
    res.send('):')
  })
}