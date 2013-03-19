Package.describe({
    summary: "Angular's hero that can handle Meteor's flame."
});

Package.on_use(function (api) {
    api.add_files('angular-ui.min.css', 'client');

    api.add_files('angular.min.js', 'client');
    api.add_files('angular-ui.min.js', 'client');
    api.add_files('angular-ui-ieshiv.min.js', 'client');

    api.add_files('server.js', 'server');
});