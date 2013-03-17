app.factory 'flameOn', ['$q', ($q) ->
    FlameOn = ($scope, name, options) ->
        Meteor.autosubscribe ->
            Meteor.subscribe name, options
        collection = Collection[name]

        collection:
            findAndFetch: (selector, opts) ->
                collection.find(selector, opts).fetch()
            findAll: (opts) ->
                this.find {}, opts
            find: (selector, opts) ->
                d = $q.defer()
                list = []

                col = collection.find(selector, opts)
                col.observe({
                    added: (item, i) ->
                        list.splice i, 0, item

                        d.resolve list

                        $scope.$apply() if !$scope.$$phase
                    changed: (newDocument, atIndex, oldDocument) ->
                        list.splice atIndex, 1, newDocument

                        d.resolve list

                        $scope.$apply() if !$scope.$$phase
                    moved: (document, oldIndex, newIndex) ->
                        if newIndex < oldIndex
                            list.splice oldIndex, 1
                            list.splice newIndex, 0, document
                        else
                            list.splice oldIndex, 1
                            list.splice newIndex, 0, document

                        d.resolve list

                        $scope.$apply() if !$scope.$$phase
                    removed: (oldDocument, atIndex) ->
                        list.splice atIndex, 1

                        d.resolve list

                        $scope.$apply() if !$scope.$$phase
                })

                return d.promise;
            findOne: (selector, opts) ->
                d = $q.defer()

                col = collection.find(selector, opts)
                col.observe({
                    added: (item, i) ->
                        d.resolve item

                        $scope.$apply() if !$scope.$$phase
                    # changed: (newDocument, atIndex, oldDocument) ->
                    #     console.log(arguments, 'changed');
                    # moved: (document, oldIndex, newIndex) ->
                    #     console.log(arguments, 'moved');
                    # removed: (oldDocument, atIndex) ->
                    #     console.log(arguments, 'removed');
                })

                return d.promise;
            insert: (doc) ->
                d = $q.defer()

                # Remove angular object element such as $$hashKey
                doc = angular.fromJson(angular.toJson(doc))

                collection.insert doc, (err, result) ->
                    return d.reject err if err

                    d.resolve result

                    $scope.$apply() if !$scope.$$phase

                return d.promise;
            update: (selector, modifier, opts) ->
                d = $q.defer()

                # Remove angular object element such as $$hashKey
                modifier = angular.fromJson(angular.toJson(modifier))

                collection.update selector, modifier, opts, (err) ->
                    return d.reject err if err
                    d.resolve 'updated'

                return d.promise;
            remove: (selector) ->
                d = $q.defer()

                collection.remove selector, (err) ->
                    return d.reject err if err
                    d.resolve 'removed'

                return d.promise;
]