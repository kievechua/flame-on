Package.describe({
    summary: "Angular's hero that can handle Meteor's flame."
});

Package.on_use(function (api) {
    // Use Meteor's library
    api.use('coffeescript', ['client', 'server']);

    // Dependencies
    // Dependencies js
    api.add_files('components/angular/angular.min.js', 'client');

    // Main library
    api.add_files('flameOn.coffee', 'client');

    // Server site file
    api.add_files('server.coffee', 'server');
});