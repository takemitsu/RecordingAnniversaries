
mainControllers.controller 'AnnivIndexController', ($scope, $http, $location, $routeParams, $modal, $log) ->

	$scope.loadDetail = ->
		$http.get "/api/entities/pickup"
		.success (data) ->
			$scope.entities = data
		.error (data) ->
			$log.info(data)

	$scope.loadDetail()
