# assume's jQuery. (bower install jquery)
module.exports = class HttpBrowserWrapper

    constructor: (@$) ->

    sendRequest = (url, data, method, headers) ->
        return @$.ajax(url, {
            data: data,
            headers: headers,
            contentType: "application/json",
            dataType: "json",
            type: method,
            cache: false,
            error: (obj, status, error) ->
                console.log('Error during request: (' + status + ') ' + error);

        })

    request: (params, callback) ->
        params.method = "GET" unless params.method?
        params.host = params.hostname if (!params.host? and params.hostname?)
        params.scheme = window.location.protocol.split(':')[0] unless params.scheme?
        params.scheme = 'http' if params.scheme == 'file'
        params.data = {} unless params.data?
        params.data = params.body if params.body?
        params.headers = {} unless params.headers?

        url = params.scheme+"://"+params.host+":"+params.port+params.path

        return sendRequest(url, params.data, params.method, params.headers).done((result) ->
                callback(null,result)
            ).fail( () ->
                callback("Failed",null)
            )
