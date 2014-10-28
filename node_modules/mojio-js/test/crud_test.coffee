MojioClient = require '../lib/nodejs/MojioClient'
config = require './config/mojio-config.coffee'

mojio_client = new MojioClient(config)

assert = require("assert")
testdata = require('./data/mojio-test-data')
should = require('should')

describe 'Get_CRUD', ->

    it 'can get resource', (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            mojio_client.request(
                {
                    resource: 'Apps',
                    method: 'GET',
                    parameters:
                        {
#                            limit: 5,
#                            offset: 10,
#                            sortBy: '_id'
                        }
                },
                (error, result) ->
                    (error?).should.be.false
                    result.should.be.an.instanceOf(Object)
                    done()
            )
        )

#describe 'Post_CRUD', ->
#
#    it 'can post resource', (done) ->
#        mojio.login(testdata.username, testdata.password, (error, result) ->
#            (error==null).should.be.true
#            mojio.should.be.an.instanceOf(Mojio)
#            mojio.token.should.be.ok
#            result.should.be.an.instanceOf(Object)
#            result._id.should.be.an.instanceOf(String)
#            mojio.Request(
#                {
#                    resource: 'Apps',
#                    method: 'POST',
#                    body: {
#                        blah: "akds"
#                        blah: "asdf",
#                        blah:
#                            {
#                                blah: "LHK",
#                                blah: "LHK"
#                            }
#                    }
#                },
#            (error, result) ->
#                (error==null).should.be.true
#                result.should.be.an.instanceOf(Object)
#                done
#            )
#        )
#
#describe 'Put_CRUD', ->
#
#    it 'can put resource', (done) ->
#        mojio.login(testdata.username, testdata.password, (error, result) ->
#            (error==null).should.be.true
#            mojio.should.be.an.instanceOf(Mojio)
#            mojio.token.should.be.ok
#            result.should.be.an.instanceOf(Object)
#            result._id.should.be.an.instanceOf(String)
#            mojio.Request(
#                {
#                    resource: 'Apps',
#                    method: 'PUT',
#                    body: {
#                        blah: "akds"
#                        blah: "asdf",
#                        blah:
#                        {
#                            blah: "LHK",
#                            blah: "LHK"
#                        }
#                    }
#                },
#                (error, result) ->
#                    (error==null).should.be.true
#                    result.should.be.an.instanceOf(Object)
#                    done
#            )
#        )
#
#describe 'Delete_CRUD', ->
#
#    it 'can delete resource', (done) ->
#        mojio.login(testdata.username, testdata.password, (error, result) ->
#            (error==null).should.be.true
#            mojio.should.be.an.instanceOf(Mojio)
#            mojio.token.should.be.ok
#            result.should.be.an.instanceOf(Object)
#            result._id.should.be.an.instanceOf(String)
#            mojio.Request(
#                {
#                    resource: 'Apps',
#                    method: 'DELETE',
#                    id: '8123841234-12341234-12341234-12341324123'
#                },
#                (error, result) ->
#                    (error==null).should.be.true
#                    result.should.be.an.instanceOf(Object)
#                    done
#            )
#        )
#
