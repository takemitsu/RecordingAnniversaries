
mainControllers.controller 'AnnivIndexController', ($scope, $http, $location, $routeParams, $modal, $log) ->

	$scope.loadDetail = ->
		$http.get "/api/entities/pickup"
		.success (data) ->
			$scope.entities = data
			if data.length is 0
				location.href = "#/list"
		.error (data) ->
			$log.info(data)

	$scope.loadDetail()
