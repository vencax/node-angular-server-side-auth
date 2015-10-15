
should = require 'should'
request = require 'request'

module.exports = (ctx, addr) ->

  sauron =
    uname: 'sauron'
    name: 'Wizard Sauron'
    email: 'jdfsk@dasda.cz'
    passwd: 'fkdjsfjs'

  it "must create sauron", (done)->
    request
      url: "#{addr}/"
      body: sauron
      json: true,
      method: 'post'
    , (err, res, body) ->
      return done err if err

      res.statusCode.should.eql 201
      body = JSON.parse(body)
      body.should.eql 2
      sauron.id = body
      done()

  it "must get sauron", (done) ->
    request "#{addr}/#{sauron.id}", (err, res, body) ->
      return done(err) if err

      res.statusCode.should.eql 200
      body = JSON.parse(body)
      body.uname.should.eql sauron.uname
      body.name.should.eql sauron.name
      body.email.should.eql sauron.email
      done()

  it "must list all users", (done) ->
    request "#{addr}/", (err, res, body) ->
      return done(err) if err

      res.statusCode.should.eql 200
      body = JSON.parse(body)
      body.length.should.eql 2
      done()

  it "must update user", (done) ->

    request
      url: "#{addr}/#{sauron.id}"
      body:
        email: 'updated@fjdskl.cz'
        gid: 1
      json: true,
      method: 'put'
    , (err, res, body) ->
      return done err if err

      res.statusCode.should.eql 200
      body.uname.should.eql sauron.uname
      body.gid.should.eql 1
      body.email.should.eql 'updated@fjdskl.cz'
      done()

  it "must NOT update notexistent user", (done) ->

    request
      url: "#{addr}/notexistent"
      body:
        email: 'updated@fjdskl.cz'
        gid: 1
      json: true,
      method: 'put'
    , (err, res, body) ->
      return done err if err

      res.statusCode.should.eql 404
      done()

  it "must remove user", (done) ->

    request
      url: "#{addr}/#{sauron.id}"
      method: 'delete'
    , (err, res, body) ->
      return done err if err

      res.statusCode.should.eql 200
      body.should.eql 'deleted'
      done()

  it "must NOT remove notexistent user", (done) ->

    request
      url: "#{addr}/notexistent"
      method: 'delete'
    , (err, res, body) ->
      return done err if err

      res.statusCode.should.eql 404
      done()
