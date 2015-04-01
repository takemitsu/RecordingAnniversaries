
mainApp = angular.module 'mainApp', [
  'ngRoute'
#  'ngSanitize'
#  'mainFactories'
  'mainControllers'
  'ui.bootstrap'
#  'angularFileUpload'
#  'hc.marked'
#  'ui.utils'
]

mainApp.config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/index',
      templateUrl: '/partials/anniv/index.html'
      controller: 'AnnivIndexController'
    # entity
    #.when '/entity',
    #  templateUrl: '/partials/entity/index.html'
    #  controller: 'EntityIndexController'
    #.when '/entity/:id',
    #  templateUrl: '/partials/entity/detail.html'
    #  controller: 'EntityDetailController'

    .otherwise
      redirectTo: '/index'
]


mainControllers = angular.module 'mainControllers', []


showMessage = (type, message, autoclose=true) ->
    $('#message .alert').addClass('alert-'+type).empty().append(message)
    $('#message').removeClass('hidden').show 'fade'
    if autoclose
        setTimeout ->
            $('#message').hide 'fade', ->
                $('#message .alert').removeClass('alert-'+type)
        , 2000
showSuccessMessage = (message) ->
    showMessage 'success', message
showErrorMessage = (message) ->
    showMessage 'danger', message

networkError = (json, status) ->
  if status != 401
    showErrorMessage json.message
  else
    location.href = '/'


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


mainControllers.controller 'EntityEditController', ($scope, $modalInstance, $http, entity) ->
    $scope.entity = $.extend {}, entity

    $scope.save = ->
        method = 'post'
        endPoint = "/api/entities"
        if entity.id
            method = 'put'
            endPoint += "/" + entity.id

        $http
            method: method
            url: endPoint
            data: $scope.entity
        .success (json) ->
            $modalInstance.close(json)
        .error networkError

    $scope.cancel = ->
        $modalInstance.dismiss('cancel')


mainControllers.controller 'DaysEditController', ($scope, $modalInstance, $http, days) ->
    $scope.days = $.extend {}, days

    $scope.today = ->
        $scope.days.anniv_at = new Date()
    $scope.clear = ->
        $scope.days.anniv_at = null

    $scope.open = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        $scope.opened = true

    $scope.dateOptions =
        formatYear: 'yy'
        startingDay: 1

    $scope.format = 'yyyy-MM-dd'

    $scope.save = ->
        method = 'post'
        endPoint = "/api/entities/" + days.entity_id + "/days"

        if days.id
            method = 'put'
            endPoint += "/" + days.id

        $http
            method: method
            url: endPoint
            data: $scope.days
        .success (json) ->
            $modalInstance.close(json)
        .error networkError

    $scope.cancel = ->
        $modalInstance.dismiss('cancel')
