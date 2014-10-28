MojioClient = require '../lib/nodejs/MojioClient'
config = require './config/mojio-config.coffee'

mojio_client = new MojioClient(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Get_Schema', ->

    it 'can get resource', (done) ->
        mojio_client.schema((error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            done()
        )