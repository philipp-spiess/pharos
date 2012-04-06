var pharos = require('../app')
  , should = require('should')
  , assert = require('assert')
  , request = require('./support/http')

describe('app', function() {
  it('should inherit from event emitter', function(done) {
    pharos.on('foo', done)
    pharos.emit('foo')
  })

  it('should require authentification', function(done) {
    request(pharos)
      .get('/')
      .end(function(res, body) {
        res.statusCode.should.equal(401)
        res.headers.should.have.property('www-authenticate')
        body.should.equal('{"error":"Authentication failed"}')
        done()
      })
  })

  it('should serve /pharos.js without authentification', function(done) {
    request(pharos)
      .get('/pharos.js')
      .end(function(res, body) {
        res.statusCode.should.equal(200)
        done()
      })
  })

  it('should serve /pharos.min.js without authentification', function(done) {
    request(pharos)
      .get('/pharos.min.js')
      .end(function(res, body) {
        res.statusCode.should.equal(200)
        done()
      })
  })

})