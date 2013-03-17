Package.describe({
    summary: "Angularjs"
});

Package.on_use(function (api) {
    api.use(['mongo-livedata']);

    api.add_files('angular-ui.min.css', 'client');

    api.add_files('angular.min.js', 'client');
    api.add_files('angular-ui.min.js', 'client');
    api.add_files('angular-ui-ieshiv.min.js', 'client');

    api.add_files('server.js', 'server');
});