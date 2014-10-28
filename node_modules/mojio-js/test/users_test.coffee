MojioClient = require '../lib/nodejs/MojioClient'
User = require '../lib/models/User'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

testObject = null

describe 'User', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test User

    it 'can query Users by UserName', (done) ->

        mojio_client.query(User, {criteria: {UserName: 'anonymous'}, limit: 10}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            for instance in result.Objects
                instance.should.be.an.instanceOf(User)
                instance.UserName.should.equal("anonymous")
            done()
        )

    it "can't query Users by non-accesible UserName", (done) ->

        mojio_client.query(User, {criteria: {UserName: 'robblovell'}, limit: 10}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            result.Objects.length.should.equal(0);
            done()
        )