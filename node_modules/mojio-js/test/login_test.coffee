MojioClient = require '../lib/nodejs/MojioClient'
config = require './config/mojio-config.coffee'

mojio_client = new MojioClient(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Login', ->

    it 'can login', (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            mojio_client.auth_token.should.be.ok
            result.should.be.an.instanceOf(Object)
            result._id.should.be.an.instanceOf(String)
            done()
        )

describe 'Logout', ->

    it 'can logout', (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            mojio_client.logout((error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                (mojio_client.auth_token==null).should.be.true
                done()
            )
        )
