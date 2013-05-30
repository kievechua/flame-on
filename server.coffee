if typeof Npm is 'undefined'
    connect = __meteor_bootstrap__.require 'connect'
    fs = __meteor_bootstrap__.require 'fs'
    path = __meteor_bootstrap__.require 'path'
    Fiber = __meteor_bootstrap__.require 'fibers'
else
    connect = Npm.require 'connect'
    fs = Npm.require 'fs'
    path = Npm.require 'path'
    Fiber = Npm.require 'fibers'

__meteor_bootstrap__.app.use(connect.query()).use (req, res, next) ->
    # Need to create a Fiber since we're using synchronous http calls
    Fiber(->
        try
            code = fs.readFileSync(path.resolve('bundle/app.html'))
        catch e
            try
                code = fs.readFileSync(path.resolve('.meteor/local/build/app.html'))
            catch eh
                code = fs.readFileSync(path.resolve('.meteor/heroku_build/app/app.html'))

        try
            angular = fs.readFileSync(path.resolve('bundle/static/angular.html'))
        catch e
            if fs.existsSync('public/angular.html')
                angular = fs.readFileSync(path.resolve('public/angular.html'))
            else
                console.log 'Angularjs\n______\nCreate public/angular.html\n This is used as your main page, this should contain the contents of the body.'

        code = new String(code)
        code = code.replace('<body>', new String(angular))
        code = code.replace('// ##RUNTIME_CONFIG##', '__meteor_runtime_config__ = ' + JSON.stringify(__meteor_runtime_config__) + ';')    if typeof __meteor_runtime_config__ isnt 'undefined'
        res.writeHead 200,
            'Content-Type': 'text/html'

        res.write code
        res.end()
        return
    ).run()
