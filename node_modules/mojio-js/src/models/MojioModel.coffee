# the base class for models.
module.exports = class MojioModel
    @_resource: 'Schema'
    @_model: 'Model'

    constructor: (json) ->
        @_client = null
        @validate(json)

    setField: (field, value) ->
        if (@schema()[field]? || typeof value == "function")
            @[field] = value
            return @[field]
        unless (field=="_client" || field=="_schema" || field == "_resource" || field == "_model" ||
                field=="_AuthenticationType" || field=="AuthenticationType" ||
                field=="_IsAuthenticated" || field=="IsAuthenticated")
            throw "Field '"+field+"' not in model '"+@constructor.name+"'."

    getField: (field) ->
        return @[field]

    validate: (json) ->
        for field, value of json
            @setField(field, value)

    # TODO:: make it so that stringify doesn't have to be used to make a saveable json string.
#    toJSON: () ->
#        object = {}
#        object[key] = @[key] for key, value of @schema()
#        return object

    stringify: () ->
        JSON.stringify(@, @replacer)

    replacer: (key, value) ->
        if (key=="_client" || key=="_schema" || key == "_resource" || key == "_model")
            return undefined
        else
            return value

    # instance methods.
    # GET
    query: (criteria, callback) ->
        if (@_client == null)
            callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null)
            return
        if (criteria instanceof Object)
            # convert criteria to a semicolon separated list of property values.
            if (!criteria.criteria?)
                query_criteria = ""
                for property, value of criteria
                    query_criteria += "#{property}=#{value};"
                criteria = { criteria:  query_criteria }

            @_client.request({ method: 'GET',  resource: @resource(), parameters: criteria}, (error, result) =>
                callback(error, @_client.model(@model(), result))
            )
        else if (typeof criteria == "string") # instanceof only works for coffeescript classes.

            @_client.request({ method: 'GET',  resource: @resource(), parameters: {id: criteria} }, (error, result) =>
                callback(error, @_client.model(@model(), result))
            )
        else
            callback("criteria given is not in understood format, string or object.",null)

    get: (criteria, callback) ->
        @query(criteria,callback)

    # POST
    create: (callback) ->
        if (@_client == null)
            callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null)
            return
        @_client.request({ method: 'POST',  resource: @resource(), body: @stringify() }, callback)

    post: (callback) ->
        @create(callback)

    # PUT
    save: (callback) ->
        if (@_client == null)
            callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null)
            return
        @_client.request({ method: 'PUT',  resource: @resource(), body: @stringify(), parameters: {id: @_id} }, callback)

    put: (callback) ->
        @save(callback)

    # DELETE
    delete: (callback) ->
        @_client.request({ method: 'DELETE',  resource: @resource(), parameters: {id: @_id} }, callback)

    # OBSERVER
    observe: (object, subject=null, observer_callback, callback) ->
        @_client.observe(object, subject, observer_callback, callback)

    unobserve: (object, subject=null, observer_callback, callback) ->
        @_client.observe(object, subject, observer_callback, callback)

    # STORAGE
    store: (model, key, value, callback) ->
        @_client.store(model, key, value, callback)

    storage: (model, key, callback) ->
        @_client.storage(model, key, callback)

    unstore: (model, key, callback) ->
        @_client.unstore(model, key, callback)

    # Unimplemented
    statistic: (expression, callback) ->
        callback(null,true)

    # Gettors
    resource: () ->
        return @_resource

    model: ()  ->
        return @_model

    schema: () ->
        return @_schema

    authorization: (client) ->
        @_client = client
        return @

    id: () ->
        return @_id

    mock: (type, withid=false) ->
        for field, value of @schema()
            if (field == "Type")
                @setField(field,@model())
            else if (field == "UserName")
                @setField(field,"Tester")
            else if (field == "Email")
                @setField(field,"test@moj.io")
            else if (field == "Password")
                @setField(field,"Password007!")
            else if (field != '_id' or withid)
                switch (value)
                    when "Integer" then @setField(field, "0")
                    when "Boolean" then @setField(field, false)
                    when "String" then @setField(field, "test"+Math.random())

        return @
