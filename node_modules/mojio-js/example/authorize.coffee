MojioClient = @MojioClient

config = {
    application: 'f201b929-d28c-415d-9b71-8112532301cb',
    hostname: 'develop.api.moj.io',
    version: 'v1',
    port:'443',
    scheme: 'https',
    redirect_uri: 'http://localhost:63344/mojio-js/example/authorize_complete.html'
}

mojio_client = new MojioClient(config)

$( () ->

    if (config.application == 'Your-Sandbox-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application and secret keys in login.js.  <br>'
        return

    mojio_client.authorize(config.redirect_uri)
)
