var connect = __meteor_bootstrap__.require("connect");
var fs = __meteor_bootstrap__.require("fs");
var path = __meteor_bootstrap__.require("path");

__meteor_bootstrap__.app
    .use(connect.query())
    .use(function (req, res, next) {
        // Need to create a Fiber since we're using synchronous http calls
        Fiber(function() {
            var code;

            try {
               code = fs.readFileSync(path.resolve('bundle/app.html'));
            } catch(e) {
                try {
                   code = fs.readFileSync(path.resolve('bundle/app.html'));
                } catch(eh) {
                   code = fs.readFileSync(path.resolve('.meteor/local/heroku_build/app.html'));
                }
            }

            var angular = "";

            try {
                angular = fs.readFileSync(path.resolve('bundle/static/angular.html'));
            } catch(e) {
                if (fs.existsSync("public/angular.html")) {
                    angular = fs.readFileSync(path.resolve('public/angular.html'));
                } else {
                    console.log("Angularjs\n______\nCreate public/angular.html\n This is used as your main page, this should contain the contents of the body.");
                }
            }

            code = new String(code);
            code = code.replace("<body>", new String(angular));

            if (typeof __meteor_runtime_config__ !== 'undefined') {
                code = code.replace(
                    "// ##RUNTIME_CONFIG##",
                    "__meteor_runtime_config__ = " +
                        JSON.stringify(__meteor_runtime_config__) + ";"
                );
            }

            res.writeHead(200, {'Content-Type': 'text/html'});
            res.write(code);
            res.end();
            return;
        }).run();
    });