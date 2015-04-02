
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
    .when '/list',
      templateUrl: '/partials/anniv/list.html'
      controller: 'AnnivListController'
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


mainControllers.filter 'JDate', ->
  return (input, only_wayear) ->

    if not input
        return ''

    if input.length isnt 10
        return ''

    dates = input.split("-");
    if dates.length isnt 3
        return ''

    date = parseInt(dates.join(""))
    if not date
        return ''

    if dates[0] > 2099
        return ''
    if dates[1] > 12 || dates[1] is "00"
        return ''
    if dates[2] > 31 || dates[2] is "00"
        return

    if date >= 19890108
        gengo = '平成'
        wayear = dates[0] - 1988
    else if date >= 19261225
        gengo = '昭和'
        wayear = dates[0] - 1925
    else if date >= 19120730
        gengo = '大正'
        wayear = dates[0] - 1911
    else if date >= 18680125
        gengo = '明治'
        wayear = dates[0] - 1867
    else
        return ''

    if wayear is 1
        wayear = '元'

    if only_wayear is 1
        return gengo + wayear + '年'

    return gengo + wayear + '年' + dates[1] + '月' + dates[2] + '日'


mainControllers.filter 'DiffDate', ->
  return (input) ->

    # 前置き

    if not input
        return ''

    if input.length isnt 10
        return ''

    dates = input.split("-");
    if dates.length isnt 3
        return ''

    date = parseInt(dates.join(""))
    if not date
        return ''

    if dates[0] > 2099
        return ''
    if dates[1] > 12 || dates[1] is "00"
        return ''
    if dates[2] > 31 || dates[2] is "00"
        return

    # 本処理

    date = new Date(dates[0], dates[1] - 1, dates[2])
    now = new Date()
    now = new Date(now.getFullYear(), now.getMonth(), now.getDate())

    diff_date = new Date(now.getFullYear(), date.getMonth(), date.getDate())
    if now > diff_date
        diff_date = new Date(now.getFullYear() + 1, date.getMonth(), date.getDate())

    diff = diff_date - now;
    diffDay = diff / 86400000
    return diffDay


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

	$scope.loadDetail = ->
		$http.get "/api/entities/pickup"
		.success (data) ->
			$scope.entities = data
		.error (data) ->
			$log.info(data)

	$scope.loadDetail()


mainControllers.controller 'AnnivListController', ($scope, $http, $location, $routeParams, $modal, $log) ->

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
						anniv_at: ''
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


mainControllers.controller 'DaysEditController', ($scope, $modalInstance, $http, $filter, days) ->
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
        $scope.days.anniv_at = $filter('date')($scope.days.anniv_at, $scope.format)

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
