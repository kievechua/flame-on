Heavily under development, use at your own risk.

Based on https://github.com/lvbreda/Meteor_angularjs version 1.0

###Example
Quick example, should place under your model instead of controller.

````
app = angular.module 'flaming', ['flameOn']

app.controller 'listing', ['$scope', 'flameOn', ($scope, flameOn) ->
    flameOfListing = flameOn $scope, 'listing', $scope.id

    $scope.list = flameOfListing.collection.find {
    	placeId: $scope.placeId
    }, {
    	sort: {
    		name: 1
    	}
    }
]
````