angular.module('flameOn', []).factory 'flameOn', ['$q', ($q) ->
    Collection = {}

    class Collect
        constructor: (name) ->
            @collection = new Meteor.Collection name
        findAndFetch: (selector, opts) ->
            @collection.find(selector, opts).fetch()
        findAllDirectly: (list, opts) ->
            @collection.find({}, opts).observe({
                addedAt: (item, i) ->
                    list.splice i, 0, item
                changedAt: (newDocument, oldDocument, atIndex) ->
                    list.splice atIndex, 1, newDocument
                movedTo: (oldDocument, oldIndex, newIndex) ->
                    if newIndex < oldIndex
                        list.splice oldIndex, 1
                        list.splice newIndex, 0, oldDocument
                    else
                        list.splice oldIndex, 1
                        list.splice newIndex, 0, oldDocument
                removedAt: (oldDocument, atIndex) ->
                    list.splice atIndex, 1
            })
        findAll: (scope, opts) ->
            this.find scope, {}, opts
        find: (scope, selector, opts) ->
            d = $q.defer()
            list = []

            col = @collection.find(selector, opts)
            col.observe({
                addedAt: (item, i) ->
                    list.splice i, 0, item

                    d.resolve list

                    scope.$apply() if !scope.$$phase
                changedAt: (newDocument, oldDocument, atIndex) ->
                    list.splice atIndex, 1, newDocument

                    d.resolve list

                    scope.$apply() if !scope.$$phase
                movedTo: (oldDocument, oldIndex, newIndex) ->
                    if newIndex < oldIndex
                        list.splice oldIndex, 1
                        list.splice newIndex, 0, oldDocument
                    else
                        list.splice oldIndex, 1
                        list.splice newIndex, 0, oldDocument

                    d.resolve list

                    scope.$apply() if !scope.$$phase
                removedAt: (oldDocument, atIndex) ->
                    list.splice atIndex, 1

                    d.resolve list

                    scope.$apply() if !scope.$$phase
            })

            return d.promise;
        findOne: (scope, selector, opts) ->
            d = $q.defer()

            col = @collection.find(selector, opts)
            col.observe({
                addedAt: (item, i) ->
                    d.resolve item

                    scope.$apply() if !scope.$$phase
            })

            return d.promise;
        insert: (doc, cb) ->
            d = $q.defer()

            console.log 'doc', doc
            @collection.insert doc, (err, result) ->
                if err
                    cb err
                    d.reject err
                    return

                cb null, result
                d.resolve result

                # @scope.$apply() if !@scope.$$phase

            return d.promise;
        update: (selector, modifier, opts) ->
            d = $q.defer()

            if angular.isString selector
                selector = _id: selector

            delete modifier._id

            console.log modifier
            @collection.update selector, modifier, opts, (err) ->
                console.log err
                return d.reject err if err
                d.resolve 'updated'

            return d.promise;
        remove: (selector) ->
            d = $q.defer()

            @collection.remove selector, (err) ->
                return d.reject err if err
                d.resolve 'removed'

            return d.promise;

    class FlameOn
        constructor: (@name, options) ->
            if @name
                Meteor.subscribe.apply Meteor, arguments
        subscribe: (name) ->
            Meteor.subscribe.apply Meteor, arguments
        call: ->
            Meteor.call.apply Meteor, arguments
        apply: ->
            Meteor.apply.apply Meteor, arguments
        methods: ->
            Meteor.apply.methods Meteor, arguments
        status: ->
            Meteor.status()
        reconnect: ->
            Meteor.reconnect()
        connect: ->
            Meteor.apply.connect Meteor, arguments
        user: ->
            Meteor.user()
        Collection: ->
            if !Collection[@name]
                Collection[@name] = new Collect @name

            return Collection[@name]
]