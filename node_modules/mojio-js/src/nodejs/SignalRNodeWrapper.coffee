SignalR = require 'signalr-client'
module.exports = class SignalRNodeWrapper

    observer_callbacks:  {}

    observer_registry: (entity) =>
        if @observer_callbacks[entity._id]
            callback(entity) for callback in @observer_callbacks[entity._id]

    constructor: (url, hubNames, jquery) ->
        @url = url
        @hubs = {}
        @signalr = new SignalR.client(url, hubNames, null) # query not used.

    getHub: (which, callback) ->
        if @hubs[which]?
            callback(null, @hubs[which])
        else
            @hubs[which] = @signalr.hub(which);
            @hubs[which].on("Error", (data) ->
                log(data)
            )
            @hubs[which].on("UpdateEntity", @observer_registry) # observer_callback(entity)
            callback(null, @hubs[which])

    # TODO:: move callback list maintenance to separate class.
    setCallback: (id, futureCallback) ->
        if (!@observer_callbacks[id]?)
            @observer_callbacks[id] = []
        @observer_callbacks[id].push(futureCallback)
        return

    removeCallback: (id, pastCallback) ->
        if (pastCallback == null)
            @observer_callbacks[id] = []
        else
            temp = []
            # reform the obxerver_callbacks list without the given pastCallback
            for callback in @observer_callbacks[id]
                temp.push(callback) if (callback != pastCallback)
            @observer_callbacks[id] = temp
        return

    subscribe: (hubName, method, subject, object, futureCallback, callback) ->
        @setCallback(subject, futureCallback)
        @getHub(hubName, (error, hub) ->
            callback(error, null) if error?
            hub.invoke(method, object) if hub?
            callback(null, hub)
        )

    unsubscribe: (hubName, method, subject, object, pastCallback, callback) ->
        @removeCallback(subject, pastCallback)
        if (@observer_callbacks[subject].length == 0)
            @getHub(hubName, (error, hub) ->
                callback(error, null) if error?
                hub.invoke(method, object) if hub?
                callback(null, hub)
            )
        else
            callback(null, true)