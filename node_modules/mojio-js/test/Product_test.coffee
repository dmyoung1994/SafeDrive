MojioClient = require '../lib/nodejs/MojioClient'
Product = require '../lib/models/Product'
config = require './config/mojio-config.coffee'
mojio_client = new MojioClient(config)
assert = require('assert')
testdata = require('./data/mojio-test-data')
should = require('should')

testObject = null

describe 'Product', ->

    before( (done) ->
        mojio_client.login(testdata.username, testdata.password, (error, result) ->
            (error==null).should.be.true
            done()
        )
    )

    # test Product
    it 'can get Products from Model', (done) ->
        product = new Product({})
        product.authorization(mojio_client)

        product.get({}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            if (result.Objects? and result.Objects instanceof (Array))
                instance.should.be.an.instanceOf(Product) for instance in result.Objects
                testObject = instance  # save for later reference.
            else
                result.should.be.an.instanceOf(Product)
                testObject = result
            done()
        )

    it 'can get Products', (done) ->

        mojio_client.get(Product, {}, (error, result) ->
            (error==null).should.be.true
            mojio_client.should.be.an.instanceOf(MojioClient)
            result.Objects.should.be.an.instanceOf(Array)
            instance.should.be.an.instanceOf(Product) for instance in result.Objects
            done()
        )

    it 'can create, find, save, and delete Product', (done) ->
        product = new Product().mock()

        mojio_client.post(product, (error, result) ->
            (error==null).should.be.true
            product = new Product(result)

            mojio_client.get(Product, product.id(), (error, result) ->
                (error==null).should.be.true
                mojio_client.should.be.an.instanceOf(MojioClient)
                result.should.be.an.instanceOf(Product)

                mojio_client.put(result, (error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    product = new Product(result)

                    mojio_client.delete(product, (error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )
            )
        )

    it 'can create, save, and delete Product from model', (done) ->
        # todo define entityType as an enum to be used here.
        product = new Product().mock()
        product.authorization(mojio_client)
        product._id = null;

        product.post((error, result) ->
            (error==null).should.be.true
            result.should.be.an.instanceOf(Object)
            product = new Product(result)
            product.authorization(mojio_client)

            product.get(product.id(), (error, result) ->
                result.should.be.an.instanceOf(Product)
                product = new Product(result)
                product.authorization(mojio_client)

                product.put((error, result) ->
                    (error==null).should.be.true
                    result.should.be.an.instanceOf(Object)
                    product = new Product(result)
                    product.authorization(mojio_client)

                    product.delete((error, result) ->
                        (error==null).should.be.true
                        (result.result == "ok").should.be.true
                        done()
                    )
                )

            )
        )