MojioClient = @MojioClient

config = {
    application: 'f201b929-d28c-415d-9b71-8112532301cb',
    hostname: 'develop.api.moj.io',
    version: 'v1',
    port:'443',
    scheme: 'https',
    redirect_uri: 'http://localhost:63344/mojio-js/example/authorize.html'
}

mojio_client = new MojioClient(config)
App = mojio_client.model('App')

$( () ->
    if (config.application == 'Your-Sandbox-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application and secret keys in authorize.js.  <br>'
        return

    mojio_client.token((error, result) ->
        if (error)
            alert("Authorize Redirect, token could not be retreived:"+error)
        else
            alert("Authorization Successful.")

            div = document.getElementById('result')
            div.innerHTML += 'POST /login<br>'
            div.innerHTML += JSON.stringify(result)
            mojio_client.query(App, {}, (error, result) ->
                if (error)
                    div = document.getElementById('result2')
                    div.innerHTML += 'Get Apps Error'+error+'<br>'
                else
                    apps = mojio_client.getResults(App, result)

                    app = apps[0]
                    div = document.getElementById('result2')
                    div.innerHTML += 'Query /App<br>'
                    div.innerHTML += JSON.stringify(result)
                    alert("Hit Ok to log out and return to the authorization page.")
                    mojio_client.unauthorize(config.redirect_uri)
            )
    )
)

