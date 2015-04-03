
mainControllers.controller 'AnnivListController', ($scope, $http, $location, $route, $routeParams, $modal, $log) ->

	$scope.maxSize = 5
	$scope.itemPerPage = 10
	$scope.totalItems = 1
	$scope.filters = {
		page: 1
	}

	$scope.loadDetail = ->
		$http.get "/api/entities",
			params: $scope.filters
		.success (data) ->
			$scope.entities = data.data
			$scope.filters.page = data.current_page
			$scope.itemPerPage = data.per_page
			$scope.totalItems = data.total
		.error (data) ->
			$log.info(data)

	$scope.loadDetail()

	$scope.addEntity = ->
		$location.path "/entity"

	$scope.editEntity = (entity) ->
		$location.path '/entity/' + entity.id

	$scope.deleteEntity = (entity) ->
		if confirm(entity.name + " を削除します。よろしいですか？")
			$http
				method: 'delete'
				url: "/api/entities/" + entity.id
			.success (json) ->
				$scope.loadDetail()
			.error networkError

	$scope.addAnniv = (entity) ->
		$location.path "/entity/" + entity.id + "/days"

	$scope.editAnniv = (entity, anniv) ->
		$location.path "/entity/" + entity.id + "/days/" + anniv.id

	$scope.deleteAnniv = (anniv) ->
		if confirm(anniv.name + " を削除します。よろしいですか？")
			$http
				method: 'delete'
				url: '/api/entities/' + anniv.entity_id + '/days/' + anniv.id
			.success (json) ->
				$scope.loadDetail()
			.error networkError
