MojioClient = require '../lib/nodejs/MojioClient'
Subscription = require '../lib/models/Subscription'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

testObject = null

describe 'Subscription', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Subscription
    it 'can get Subscriptions from Model', (done) ->
        subscription = new Subscription({})
        subscription.authorization(mojio_client)

        subscription.query({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            if (result.Objects? and result.Objects instanceof (Array))
                instance.should.be.an.instanceOf(Subscription) for instance in result.Objects
                testObject = instance  # save for later reference.
            else
                result.should.be.an.instanceOf(Subscription)
                testObject = result
            done()
        )

    it 'can get Subscriptions', (done) ->

        mojio_client.query(Subscription, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(Subscription) for instance in result.Objects
            done()
        )
