
/**
 * Module dependencies.
 */

var http = require('http')

module.exports = request;

function request(app) {
  return new Request(app);
}

function Request(app) {
  this.port = process.env.PORT || 3000
  this.host = 'localhost'
  this.client = http.createClient(this.port, this.host)
}

Request.prototype.get = function (path) {
  this.request = this.client.request('GET', path, { 'host': this.host })

  return this;
}


Request.prototype.end = function(fn){
  var self = this;

  self.request.end()

  self.request.on('response', function (res) {
    res.setEncoding('utf8')

    var body = ''
    res.on('data', function (chunk) {
     body += chunk
    })

    res.on('end', function() {
      if(typeof fn == 'function')
        fn(res, body)
    })
  })

  return this;
};
