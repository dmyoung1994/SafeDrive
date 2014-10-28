MojioClient = require '../lib/nodejs/MojioClient'
Event = require '../lib/models/Event'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

testObject = null

describe 'Event2', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Event
    it 'can get Events from Model with criteria', (done) ->
        event = new Event({})
        event.authorization(mojio_client)
        event.query({criteria: "EventType=Acceleration", limit: 10}, (error, result) ->
            console.log("error:"+error)
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            if (result.Objects? and result.Objects instanceof (Array))
                instance.should.be.an.instanceOf(Event) for instance in result.Objects
                testObject = instance  # save for later reference.
                for event in result.Objects
                    event.EventType.should.be.equal("Acceleration")
            else
                result.should.be.an.instanceOf(Event)
                testObject = result
            done()
        )