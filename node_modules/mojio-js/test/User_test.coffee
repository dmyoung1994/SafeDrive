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
    it 'can get Users from Model', (done) ->
        user = new User({})
        user.authorization(mojio_client)

        user.query({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            if (result.Objects? and result.Objects instanceof (Array))
                instance.should.be.an.instanceOf(User) for instance in result.Objects
                testObject = instance  # save for later reference.
            else
                result.should.be.an.instanceOf(User)
                testObject = result
            done()
        )

    it 'can get Users', (done) ->

        mojio_client.query(User, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(User) for instance in result.Objects
            done()
        )

    it 'can query Users', (done) ->

        mojio_client.query(User, {criteria: {name: 'robb'}, limit: 10}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(User) for instance in result.Objects
            done()
        )