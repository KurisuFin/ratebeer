function BreweriesController($scope, $http) {
	$http.get("breweries.json").success(function(data, status, headers, config) {
		$scope.breweries = data;
	});

	$scope.order = "name";

	$scope.click = function(order) {
		$scope.order = order;
	}
}