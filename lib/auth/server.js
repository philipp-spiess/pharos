
/**
 * Server-Side Auth (Push and Web-Interface)
 **/


module.exports = function(req, res, fn) {

  var req_auth = true

  if(typeof req.headers.authorization != 'undefined') {
    var auth = req.headers.authorization.replace('Basic ', '')
    auth = new Buffer(auth, 'base64').toString('ascii').split(':')
    if(auth[1] == process.env.PHAROS_PASSWORD) {
      req_auth = false
      if(typeof fn == 'function')
        fn()
    }
  } 

  if(req_auth) {
    res.header('Content-Type', 'application/json')
    res.header('WWW-Authenticate', 'Basic realm="Pharos requires a valid login."')
    res.statusCode = 401
    res.send(JSON.stringify({error:'Authentication failed'}))
  }
}