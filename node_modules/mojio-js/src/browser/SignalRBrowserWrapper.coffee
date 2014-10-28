# assume's JQuery javascript client (bower install jquery).
module.exports = class SignalRBrowserWrapper

    observer_callbacks:  {}

    observer_registry: (entity) =>
        if @observer_callbacks[entity._id]
            callback(entity) for callback in @observer_callbacks[entity._id]

    constructor: (url, hubNames, jquery) ->  # hubNames not used.
        @$ = jquery
        @url = url
        @hubs = {}
        @signalr = null
        @connectionStatus = false

    getHub: (which, callback) ->
        if (@hubs[which])
            callback(null, @hubs[which])
        else
            if (!@signalr?)
                @signalr = @$.hubConnection(@url, { useDefaultPath: false })
                @signalr.error( (error) ->
                    console.log("Connection error"+error)
                    callback(error, null)
                )

            @hubs[which] = @signalr.createHubProxy(which)

            @hubs[which].on("error", (data) ->
                console.log("Hub '"+which+"' has error"+data)
            )
            @hubs[which].on("UpdateEntity", @observer_registry)

            if (@hubs[which].connection.state != 1)
                if (!@connectionStatus)
                    @signalr.start().done( () =>
                        @connectionStatus = true
                        @hubs[which].connection.start().done( () =>
                            callback(null, @hubs[which])
                        )
                    )
                else
                    @hubs[which].connection.start().done( () =>
                        callback(null, @hubs[which])
                    )
            else
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
            if error?
                callback(error, null)
            else
                hub.invoke(method, object)
                callback(null, hub)
        )

    unsubscribe: (hubName, method, subject, object, pastCallback, callback) ->
        @removeCallback(subject, pastCallback)
        if (@observer_callbacks[subject].length == 0)
            @getHub(hubName, (error, hub) ->
                if error?
                    callback(error, null)
                else
                    hub.invoke(method, object) if hub?
                    callback(null, hub)
            )
        else
            callback(null, true)
