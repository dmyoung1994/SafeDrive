MojioClient = require '../lib/nodejs/MojioClient'
Observer = require '../lib/models/Observer'
App = require '../lib/models/App'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')
count = [0,0]
app1=null
app2=null
observer = null
describe 'Observer', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Storage
    it 'can Store, Get and Delete Data on Object', (done) ->
        console.log("Testing Storage")
        app = new App().mock()

        mojio_client.post(app, (error, result) ->
            (error==null).should.be.true
            app = new App(result)
            mojio_client.store(app, 'test_key', 'test_value', (error, result) ->
                (error==null).should.be.true
                result.result.should.equal("ok")
                mojio_client.storage(app, 'test_key', (error, result) ->
                    (error==null).should.be.true
                    result.should.equal('test_value')
                    mojio_client.unstore(app, 'test_key', (error, result) ->
                        (error==null).should.be.true
                        mojio_client.storage(app, 'test_key', (error, result) ->
                            (error==null).should.be.false
                            mojio_client.delete(app, (error, result) ->
                                (error==null).should.be.true
                                done()
                            )
                        )
                    )
                )
            )
        )