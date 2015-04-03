
mainControllers.controller 'DaysEditController', ($scope, $http, $location, $route, $routeParams, $filter, $log) ->
    $log.info $routeParams

    $scope.days = {}
    $scope.old_days = {}

    if $routeParams.id && $routeParams.entity_id
        $http.get "/api/entities/" + $routeParams.entity_id + "/days/" + $routeParams.id
        .success (json) ->
            $scope.old_days = json
            $scope.days = json
        .error networkError

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
        endPoint = "/api/entities/" + $routeParams.entity_id + "/days"

        if $routeParams.id
            method = 'put'
            endPoint += "/" + $routeParams.id

        $http
            method: method
            url: endPoint
            data: $scope.days
        .success (json) ->
            showSuccessMessage '保存しました'
            $scope.redirect()
        .error networkError

    $scope.cancel = ->
        $scope.redirect()

    $scope.redirect = ->
        $location.path "/list"
