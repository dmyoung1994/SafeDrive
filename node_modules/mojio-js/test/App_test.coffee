MojioClient = require '../lib/nodejs/MojioClient'
App = require '../lib/models/App'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

testObject = null

describe 'App', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test App
    it 'can get Apps from Model', (done) ->
        app = new App({})
        app.authorization(mojio_client)

        app.get({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            if (result.Objects? and result.Objects instanceof (Array))
                instance.should.be.an.instanceOf(App) for instance in result.Objects
                testObject = instance  # save for later reference.
            else
                result.should.be.an.instanceOf(App)
                testObject = result
            done()
        )

    it 'can get Apps', (done) ->

        mojio_client.get(App, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(App) for instance in result.Objects
            done()
        )

    it 'can create, find, save, and delete App', (done) ->
        app = new App().mock()

        mojio_client.post(app, (error, result) ->
            (error==null).should.be.true
            app = new App(result)

            mojio_client.get(App, app.id(), (error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                result.should.be.an.instanceOf(App)

                mojio_client.put(result, (error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    app = new App(result)

                    mojio_client.delete(app, (error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )
            )
        )

    it 'can create, save, and delete App from model', (done) ->
        # todo define entityType as an enum to be used here.
        app = new App().mock()
        app.authorization(mojio_client)
        app._id = null;

        app.post((error, result) ->
            (error==null).should.be.true
            result.should.be.an.instanceOf(Object)
            app = new App(result)
            app.authorization(mojio_client)

            app.get(app.id(), (error, result) ->
                result.should.be.an.instanceOf(App)
                app = new App(result)
                app.authorization(mojio_client)

                app.put((error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    app = new App(result)
                    app.authorization(mojio_client)

                    app.delete((error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )

            )
        )