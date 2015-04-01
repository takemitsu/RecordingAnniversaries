
mainControllers.controller 'AnnivIndexController', ($scope, $http, $location, $routeParams, $modal, $log) ->

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
		$scope.editEntity null
	$scope.editEntity = (entity) ->
		instance = $modal.open
			templateUrl: '/partials/entity/modal/edit.html'
			controller: 'EntityEditController'
			resolve:
				entity: ->
					if entity
						return entity
					else
						name: ''
						desc: ''
		instance.result.then (selectItem) ->
			showSuccessMessage '保存しました'
			$scope.loadDetail()
		, ->
			$log.info 'dismiss editEntity'

	$scope.deleteEntity = (entity) ->
		if confirm(entity.name + " を削除します。よろしいですか？")
			$http
				method: 'delete'
				url: "/api/entities/" + entity.id
			.success (json) ->
				$scope.loadDetail()
			.error networkError

	$scope.addAnniv = (entity) ->
		$scope.editAnniv(entity, null)
	$scope.editAnniv = (entity, anniv) ->
		instance = $modal.open
			templateUrl: '/partials/days/modal/edit.html'
			controller: 'DaysEditController'
			resolve:
				days: ->
					if anniv
						return anniv
					else
						name: ''
						desc: ''
						date: ''
						entity_id: entity.id
		instance.result.then (selectItem) ->
			showSuccessMessage '保存しました'
			$scope.loadDetail()
		, ->
			$log.info 'dismiss editAnniv'

	$scope.deleteAnniv = (anniv) ->
		if confirm(anniv.name + " を削除します。よろしいですか？")
			$http
				method: 'delete'
				url: '/api/entities/' + anniv.entity_id + '/days/' + anniv.id
			.success (json) ->
				$scope.loadDetail()
			.error networkError
