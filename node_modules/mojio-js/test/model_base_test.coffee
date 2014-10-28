MojioClient = require '../lib/nodejs/MojioClient'
App = require '../lib/models/App'
assert = require("assert")
should = require('should')

describe 'Model Base Small Stuff', ->

    it 'convert to json', (done) ->
        app = new App().mock()
        json = app.stringify(app)
        object = JSON.parse(json)
        object.Type.should.be.equal("App")
        done()