pharos = require('../app')
should = require('should')
assert = require('assert')
request = require('./support/http')

describe 'app', ->
  it 'should require authentification', (done) ->
    request(pharos)
      .get('/')
      .end (res, body) ->
        res.statusCode.should.equal 401
        res.headers.should.have.property 'www-authenticate' 
        body.should.equal '{"error":"Authentication failed"}'
        done()

  it 'should serve /pharos.js without authentification', (done) ->
    request(pharos)
      .get('/pharos.js')
      .end (res, body) ->
        res.statusCode.should.equal 200
        done()

  it 'should serve /pharos.min.js without authentification', (done) ->
    request(pharos)
      .get('/pharos.min.js')
      .end (res, body) ->
        res.statusCode.should.equal 200
        done()
      
